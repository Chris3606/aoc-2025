const std = @import("std");

pub var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = gpa_impl.allocator();

/// Gets an iterator which breaks the input up into lines and returns each line.
pub fn tokenizeLines(input: []const u8) std.mem.TokenIterator(u8, .scalar) {
    return std.mem.tokenizeScalar(u8, input, '\n');
}

/// Parses the given input into lines, and returns them as a slice of strings.
/// The inner slices point at the input data so do not allocate more memory.
pub fn parseLines(alloc: std.mem.Allocator, input_data: []const u8) ![][]const u8 {
    var vec: std.ArrayList([]const u8) = .empty;
    defer vec.deinit(alloc);

    var it = tokenizeLines(input_data);
    while (it.next()) |line| {
        try vec.append(alloc, line);
    }

    return vec.toOwnedSlice(alloc) catch unreachable;
}

/// Represents an error that occurs during parsing.
pub const ParsingError = error{InvalidData};

/// A structure representing a range starting and ending at the given values.  The end is exclusive,
/// while the beginning is inclusive.
pub const Range = struct {
    const Self = @This();

    /// Inclusive
    begin: i64,
    /// Exclusive
    end: i64,

    /// Initializes from data in format [min]-[max] (where max is inclusive)
    pub fn initFromSerialized(string: []const u8) !Self {
        var it = std.mem.tokenizeScalar(u8, string, '-');
        const min_data = try (it.next() orelse ParsingError.InvalidData);
        const max_data = try (it.next() orelse ParsingError.InvalidData);
        const min = try std.fmt.parseInt(i64, min_data, 10);
        const max = try std.fmt.parseInt(i64, max_data, 10) + 1;

        if (max <= min) return ParsingError.InvalidData;

        return Self{
            .begin = min,
            .end = max,
        };
    }
};

/// Parses a list of range in the format [min]-[max],[min]-max,...
pub fn parseRangeList(alloc: std.mem.Allocator, input_data: []const u8) ![]Range {
    var vec: std.ArrayList(Range) = .empty;
    defer vec.deinit(alloc);

    var it = std.mem.tokenizeScalar(u8, input_data, ',');
    while (it.next()) |range_data| {
        try vec.append(alloc, try Range.initFromSerialized(range_data));
    }

    return vec.toOwnedSlice(alloc) catch unreachable;
}

/// Represents a 2D integral point.  Provides mathematical helper functions.
pub const Point = struct {
    const Self = @This();

    /// X-coordinate of the point.
    x: i32,
    /// Y-coordinate of the point.
    y: i32,

    /// Converts the point to a 1D index, assuming the given width.
    pub fn toIndex(self: Self, width: u32) usize {
        return xyToIndex(self.x, self.y, width);
    }

    /// Converts the given coordinates to a 1D index, assuming the given width.
    pub fn xyToIndex(x: i32, y: i32, width: u32) usize {
        return @as(usize, @intCast(y)) * width + @as(usize, @intCast(x));
    }

    /// Converts the given 1D index into a Point, assuming the given width was used to calculate the index.
    pub fn fromIndex(index: usize, width: u32) Self {
        return Self{ .x = xFromIndex(index, width), .y = yFromIndex(index, width) };
    }

    /// Retrieves the x-value for the location encoded by the given index, assuming the given width was used to calculate the index.
    pub fn xFromIndex(index: usize, width: u32) i32 {
        return @intCast(index % @as(usize, width));
    }

    /// Retrieves the y-value for the location encoded by the given index, assuming the given width was used to calculate the index.
    pub fn yFromIndex(index: usize, width: u32) i32 {
        return @intCast(index / @as(usize, width));
    }

    /// Adds the specified points, returning a new one.
    pub fn addPoint(self: Self, point: Point) Point {
        return .{ .x = self.x + point.x, .y = self.y + point.y };
    }

    /// Subtracts the given point from "self", returning a new point with the results.
    pub fn subtractPoint(self: Self, point: Point) Point {
        return .{ .x = self.x - point.x, .y = self.y - point.y };
    }

    /// Translates the point in the given direction.
    pub fn addDirection(self: Self, dir: Direction) Point {
        return self.addPoint(dir.delta());
    }
};

/// Enumeration representing the possible adjacent directions on a 2D grid.
pub const Direction = enum {
    const Self = @This();

    Up,
    UpRight,
    Right,
    DownRight,
    Down,
    DownLeft,
    Left,
    UpLeft,
    None,

    /// The delta x/y values of each direction, as a point.  Indices correspond to the enum with the
    /// corresponding integral value.
    ///
    /// For now, this is const: but in order to enable support for yIncreasesUpwards settings later,
    /// if that feature is switchable at run-time, we will need it to be var.
    const deltas = [_]Point{
        .{ .x = 0, .y = -1 }, // Up
        .{ .x = 1, .y = -1 }, // UpRight
        .{ .x = 1, .y = 0 }, // Right
        .{ .x = 1, .y = 1 }, // DownRight
        .{ .x = 0, .y = 1 }, // Down
        .{ .x = -1, .y = 1 }, // DownLeft
        .{ .x = -1, .y = 0 }, // Left
        .{ .x = -1, .y = -1 }, // UpLeft
        .{ .x = 0, .y = 0 }, // None
    };

    /// All directions which are Direction.None.
    pub const eightWay = [8]Direction{ .Up, .UpRight, .Right, .DownRight, .Down, .DownLeft, .Left, .UpLeft };

    /// All cardinal directions, in clockwise order.
    pub const cardinals = [4]Direction{ .Up, .Right, .Down, .Left };

    /// All diagonal directions, in clockwise order.
    pub const diagonals = [4]Direction{ .UpRight, .DownRight, .DownLeft, .UpLeft };

    /// Gets the delta x/y values for the given direction as a Point.
    pub fn delta(self: Self) Point {
        return deltas[@intFromEnum(self)];
    }

    /// Moves the given direction clockwise the given number of times and returns the resulting direction.
    /// Must not be given Direction.None.
    pub fn rotateClockwise(self: Self, amount: u32) Direction {
        std.debug.assert(self != .None);

        const intValOfEnum = @as(u32, @intFromEnum(self));
        return @enumFromInt(@as(std.meta.Tag(Direction), @intCast((intValOfEnum + amount) % 8)));
    }

    /// Moves the given direction counter-clockwise the given number of times and returns the resulting direction.
    /// Must not be given Direction.None.
    pub fn rotateCounterClockwise(self: Self, amount: u32) Direction {
        return self.rotateClockwise(8 - (amount % 8));
    }
};

/// Enumeration representing different methods of calculating distance on a 2d integral grid.
pub const Distance = enum {
    const Self = @This();

    /// "4-way" adjacency; distance is the sum of the difference in x values and difference in y values between two points.
    Manhattan,

    /// "8-way" adjacency; distance is the maximum of the dx and dy values.  Represents 8-way movement with diagonals costing the
    /// same as cardinals.
    Chebyshev,

    /// Standard 2D grid mathematical distance; diagonals are about 1.41x farther away than cardinals.
    Euclidean,

    /// Calculate distance between origin and the point specified.
    pub fn distanceFromDelta(self: Self, delta: Point) f64 {
        return switch (self) {
            .Manhattan, .Chebyshev => @floatFromInt(self.magnitudeFromDelta(delta)),
            .Euclidean => std.math.sqrt(@floatFromInt(self.magnitudeFromDelta(delta))),
        };
    }

    /// Calculate the distance between the two points specified.
    pub fn distanceBetweenPoints(self: Self, p1: Point, p2: Point) f64 {
        return self.distanceFromDelta(.{ .x = p2.x - p1.x, .y = p2.y - p1.y });
    }

    /// Calculates a magnitude value for the distance between the origin and the point specified.
    ///
    /// See magnitudeBetweenPoints for more information
    pub fn magnitudeFromDelta(self: Self, delta: Point) u32 {
        const dx = std.math.absCast(delta.x);
        const dy = std.math.absCast(delta.y);

        return switch (self) {
            .Manhattan => dx + dy,
            .Chebyshev => std.math.max(dx, dy),
            .Euclidean => dx * dx + dy * dy,
        };
    }

    /// Calculate a value representing the "magnitude" of the distance between the two points.
    ///
    /// In other words, given two sets of points set A and set B, where set A
    /// has a greater distance between them than set B:
    ///     - magnitudeFromDelta(set A) > magnitudeFromDelta(set B)
    ///
    /// The value is intended to be quicker to compute than the actual distance, and as such is
    /// useful if all you need is to compare two distances.
    pub fn magnitudeBetweenPoints(self: Self, p1: Point, p2: Point) u32 {
        return self.magnitudeFromDelta(.{ .x = p2.x - p1.x, .y = p2.y - p1.y });
    }
};

/// Used in grid view context for determining how to get/set values.
const ValueFuncType = enum { XYVal, PointVal, IndexVal };

/// Iterator which takes a grid defined by width and height, and produces an iterator over all positions within that grid.
pub const GridPositionsIterator = struct {
    const Self = @This();

    count: u32,
    width: u32,
    cur: u32,

    pub fn init(width: u32, height: u32) Self {
        return .{
            .cur = 0,
            .width = width,
            .count = width * height,
        };
    }

    pub fn next(self: *Self) ?Point {
        if (self.cur >= self.count) return null;

        const point = Point.fromIndex(self.cur, self.width);
        self.cur += 1;
        return point;
    }
};

/// Creates a grid view from the given context type TContext, which must wrap a struct with the following function prototypes:
///     - fn width(Self): u32
///     - fn height(Self): u32
///
/// It must also implement ONE (and ONLY ONE) of the following functions:
///     - fn getValueXY(Self, x: i32, y: i32) TValue
///     - fn getValuePoint(Self, Point) TValue
///     - fn getValueIndex(Self, usize) TValue
///
/// The implemented function must, given a position in the specified form, retrieve the value from the view at that location.
///
/// TContext may also (optionally) implement the following functions:
///     - fn deinit(Self) void
///
/// If it implements deinit, that function will be called when the GridView's deinit is called.
///
/// These functions may use any calling convention (including inline!); they must simply match the parameter and names in the prototypes
/// shown.
///
/// This could also be done with function pointers; however, doing it this way easily enforces the invariant that these functions cannot
/// change to point to different functions after compile-time.  This prevents unnecessary pointer storage and dereferencing, and enables
/// the compiler to inline the context functions themselves just as it might any other function; it effectively makes this a 0 runtime
/// overhead abstraction.
pub fn GridView(comptime TContext: type, comptime TValue: type) type {
    // TODO: This could assert that the things are actually functions and such as well.
    comptime {
        var count: u32 = 0;
        if (@hasDecl(TContext, "getValueXY")) count += 1;
        if (@hasDecl(TContext, "getValuePoint")) count += 1;
        if (@hasDecl(TContext, "getValueIndex")) count += 1;

        if (count != 1)
            @compileError("Context type must implement ONE AND ONLY ONE of getValueXY, getValuePoint, and getValueIndex.");
    }

    return struct {
        const Self = @This();

        /// The context struct containing the required functions.
        context: TContext,

        /// Initialize the grid view using the given context.
        pub fn init(context: TContext) Self {
            return Self{ .context = context };
        }

        /// Deinitialize the grid view, ensuring that the context is deinitialized if it has a deinit function.
        pub fn deinit(self: Self) void {
            // TODO: Check that it's actually the correct function?
            if (@hasDecl(TContext, "deinit")) {
                self.context.deinit();
            }
        }

        /// The width of the view.
        pub fn width(self: Self) u32 {
            return self.context.width();
        }

        /// The height of the view.
        pub fn height(self: Self) u32 {
            return self.context.height();
        }

        /// Returns whether or not the grid view contains the point given.
        pub fn contains(self: Self, point: Point) bool {
            return point.x >= 0 and point.x < self.width() and point.y >= 0 and point.y < self.height();
        }

        /// Returns an iterator over all of the positions within the grid.
        pub fn positions(self: Self) GridPositionsIterator {
            return GridPositionsIterator.init(self.width(), self.height());
        }

        /// Returns the number of cells in the grid view.
        pub fn numCells(self: Self) u32 {
            return self.width() * self.height();
        }

        /// Gets the value for the view at the given location.
        pub fn getValueXY(self: Self, x: i32, y: i32) TValue {
            return switch (comptime getValueFuncType()) {
                .XYVal => self.context.getValueXY(x, y),
                .PointVal => self.context.getValuePoint(.{ .x = x, .y = y }),
                .IndexVal => self.context.getValueIndex(Point.xyToIndex(x, y, self.width())),
            };
        }

        /// Gets the value for the view at the given location.
        pub fn getValuePoint(self: Self, point: Point) TValue {
            return switch (comptime getValueFuncType()) {
                .XYVal => self.context.getValueXY(point.x, point.y),
                .PointVal => self.context.getValuePoint(point),
                .IndexVal => self.context.getValueIndex(point.toIndex(self.width())),
            };
        }

        /// Gets the value for the view at location represented by the given 1D index.
        pub fn getValueIndex(self: Self, index: usize) TValue {
            return switch (comptime getValueFuncType()) {
                .XYVal => self.context.getValueXY(
                    Point.xFromIndex(index, self.width()),
                    Point.yFromIndex(index, self.width()),
                ),
                .PointVal => self.context.getValuePoint(Point.fromIndex(index, self.width())),
                .IndexVal => self.context.getValueIndex(index),
            };
        }

        fn getValueFuncType() ValueFuncType {
            if (@hasDecl(TContext, "getValueXY")) return .XYVal;
            if (@hasDecl(TContext, "getValuePoint")) return .PointVal;
            if (@hasDecl(TContext, "getValueIndex")) return .IndexVal;
        }
    };
}

/// Exactly like GridView(TContext, TValue), except for the context is required to expose functions
/// to allow setting of the values at locations as well.
///
/// Specifically, in addition to meeting all requirements for grid view, the context must also
/// implement ONE (and ONLY ONE) of the following functions:
///     - fn setValueXY(*Self, x: i32, y: i32, value: TValue) void
///     - fn setValuePoint(*Self, Point, TValue) void
///     - fn setValueIndex(*Self, usize, TValue) void
///
/// The implemented function must, given a position in the specified form and a value of the proper type,
/// set the value in the view at that location to the given value.
pub fn SettableGridView(comptime TContext: type, comptime TValue: type) type {
    // TODO: This could assert that the things are actually functions and such as well.
    comptime {
        var count: u32 = 0;
        if (@hasDecl(TContext, "setValueXY")) count += 1;
        if (@hasDecl(TContext, "setValuePoint")) count += 1;
        if (@hasDecl(TContext, "setValueIndex")) count += 1;

        if (count != 1)
            @compileError("Context type must implement ONE AND ONLY ONE of setValueXY, setValuePoint, and setValueIndex.");
    }

    return struct {
        const Self = @This();

        /// Basic (read-only) view containing the context.
        basicView: GridView(TContext, TValue),

        /// Initialize the grid view using the given context.
        pub fn init(context: TContext) Self {
            return Self{ .basicView = GridView(TContext, TValue).init(context) };
        }

        /// Deinitialize the grid view, ensuring that the context is deinitialized if it has a deinit function.
        pub fn deinit(self: Self) void {
            self.basicView.deinit();
        }

        /// The width of the view.
        pub fn width(self: Self) u32 {
            return self.basicView.width();
        }

        /// The height of the view.
        pub fn height(self: Self) u32 {
            return self.basicView.height();
        }

        /// Returns whether or not the grid view contains the point given.
        pub fn contains(self: Self, point: Point) bool {
            return self.basicView.contains(point);
        }

        /// Returns an iterator over all of the positions within the grid.
        pub fn positions(self: Self) GridPositionsIterator {
            return self.basicView.positions();
        }

        /// Returns the number of cells in the grid view.
        pub fn numCells(self: Self) u32 {
            return self.basicView.numCells();
        }

        /// Gets the value for the view at the given location.
        pub fn getValueXY(self: Self, x: i32, y: i32) TValue {
            return self.basicView.getValueXY(x, y);
        }

        /// Gets the value for the view at the given location.
        pub fn getValuePoint(self: Self, point: Point) TValue {
            return self.basicView.getValuePoint(point);
        }

        /// Gets the value for the view at location represented by the given 1D index.
        pub fn getValueIndex(self: Self, index: usize) TValue {
            return self.basicView.getValueIndex(index);
        }

        /// Sets the value for the view at the given location.
        pub fn setValueXY(self: *Self, x: i32, y: i32, value: TValue) void {
            return switch (comptime setValueFuncType()) {
                .XYVal => self.basicView.context.setValueXY(x, y, value),
                .PointVal => self.basicView.context.setValuePoint(.{ .x = x, .y = y }, value),
                .IndexVal => self.basicView.context.setValueIndex(Point.xyToIndex(x, y, self.width()), value),
            };
        }

        /// Sets the value for the view at the given location.
        pub fn setValuePoint(self: *Self, point: Point, value: TValue) void {
            return switch (comptime setValueFuncType()) {
                .XYVal => self.basicView.context.setValueXY(point.x, point.y, value),
                .PointVal => self.basicView.context.setValuePoint(point, value),
                .IndexVal => self.basicView.context.setValueIndex(point.toIndex(self.width()), value),
            };
        }

        /// Sets the value for the view at location represented by the given 1D index.
        pub fn setValueIndex(self: *Self, index: usize, value: TValue) void {
            return switch (comptime setValueFuncType()) {
                .XYVal => self.basicView.context.setValueXY(
                    Point.xFromIndex(index, self.width()),
                    Point.yFromIndex(index, self.width()),
                    value,
                ),
                .PointVal => self.basicView.context.setValuePoint(Point.fromIndex(index, self.width()), value),
                .IndexVal => self.basicView.context.setValueIndex(index, value),
            };
        }

        fn setValueFuncType() ValueFuncType {
            if (@hasDecl(TContext, "setValueXY")) return .XYVal;
            if (@hasDecl(TContext, "setValuePoint")) return .PointVal;
            if (@hasDecl(TContext, "setValueIndex")) return .IndexVal;
        }
    };
}

/// Context for a creating a [Settable]GridView that exposes a slice.  It may or may not take ownership of the slice,
/// depending on the method by which it was created.
pub fn SliceViewContext(comptime TValue: type) type {
    return struct {
        const Self = @This();

        /// Slice being wrapped by this view context.
        slice: []TValue,
        /// Allocator used to allocate the slice, if any; null indicates the context does not own the slice.
        allocator: ?std.mem.Allocator,
        /// Value for the width of the grid view.
        widthVal: u32,
        /// Value for the height of the grid view.
        heightVal: u32,

        /// Initialize the context by creating a new slice allocated with the given allocator.
        pub fn initNewBuffer(allocator: std.mem.Allocator, widthVal: u32, heightVal: u32) !Self {
            var val = Self{
                .slice = undefined,
                .allocator = allocator,
                .widthVal = widthVal,
                .heightVal = heightVal,
            };
            val.slice = try allocator.alloc(TValue, widthVal * heightVal);

            return val;
        }

        /// Initializes the context with the given (pre-existing) slice.  It takes ownership of the slice,
        /// and will use the given allocator to free it when deinit is called.
        pub fn initOwned(allocator: std.mem.Allocator, slice: []TValue, widthVal: u32) Self {
            return Self{
                .slice = slice,
                .allocator = allocator,
                .widthVal = widthVal,
                .heightVal = @intCast(slice.len / widthVal),
            };
        }

        /// Initializes the context with the given (pre-existing slice).  IT DOES NOT ASSUME OWNERSHIP
        /// of the slice, and therefore ensuring that the backing memory for the slice is freed is the caller's
        /// responsibility.
        pub fn initUnowned(slice: []TValue, widthVal: u32) Self {
            return Self{
                .slice = slice,
                .allocator = null,
                .widthVal = widthVal,
                .heightVal = @intCast(slice.len / widthVal),
            };
        }

        /// Deinitializes the context, freeing the slice memory if it owns that memory.
        pub fn deinit(self: Self) void {
            if (self.allocator) |alloc| {
                alloc.free(self.slice);
            }
        }

        /// The width of the view.
        pub fn width(self: Self) u32 {
            return self.widthVal;
        }

        /// The width of the view.
        pub fn height(self: Self) u32 {
            return self.heightVal;
        }

        /// Gets the value for the view at the specified location, given as a 1D index.
        pub fn getValueIndex(self: Self, index: usize) TValue {
            return self.slice[index];
        }

        /// Sets the value for the view at the specified location, given as a 1D index.
        pub fn setValueIndex(self: *Self, index: usize, value: TValue) void {
            self.slice[index] = value;
        }
    };
}

/// Creates a SliceView, which is a SettableGridView that exposes a slice.  See SliceViewContext for details
/// about memory ownership.
pub fn SliceView(comptime TValue: type) type {
    return SettableGridView(SliceViewContext(TValue), TValue);
}

/// Parses a grid in this format:
/// 30373
/// 25512
/// 65332
/// 33549
/// 35390
pub fn parseSliceViewFromDigitGrid(allocator: std.mem.Allocator, data: []const u8) !SliceView(u8) {
    var list: std.ArrayList(u8) = .empty;
    defer list.deinit(allocator);

    var width: u32 = 0;

    var it = tokenizeLines(data);
    while (it.next()) |line| {
        width = @intCast(line.len);
        for (line) |ch| {
            try list.append(allocator, ch - '0');
        }
    }

    return SliceView(u8).init(SliceViewContext(u8).initOwned(
        allocator,
        list.toOwnedSlice(allocator) catch unreachable,
        width,
    ));
}

/// Parses a grid in this format:
/// ABCDE
/// 12345
/// STUFF
/// STUFF
/// STUFF
///
/// If you want numerical values from a digit grid instead, try parseSliceViewFromDigitGrid
/// TODO: Generic with digit grid
pub fn parseSliceViewFromCharGrid(allocator: std.mem.Allocator, data: []const u8) !SliceView(u8) {
    var list: std.ArrayList(u8) = .empty;
    defer list.deinit(allocator);

    var width: u32 = 0;

    var it = tokenizeLines(data);
    while (it.next()) |line| {
        width = @intCast(line.len);
        for (line) |ch| {
            try list.append(allocator, ch);
        }
    }

    return SliceView(u8).init(SliceViewContext(u8).initOwned(
        allocator,
        list.toOwnedSlice(allocator) catch unreachable,
        width,
    ));
}

// /// Parses a list of integers using the specified values as the delimiters to tokenize on.
// pub fn parseIntList(comptime TInt: type, allocator: std.mem.Allocator, data: []const u8, delimeter_bytes: []const u8) !List(TInt) {
//     var list = List(TInt).init(allocator);
//     errdefer list.deinit();

//     var item_it = tokenize(u8, data, delimeter_bytes);
//     while (item_it.next()) |item| {
//         const num = try parseInt(TInt, item, 10);
//         try list.append(allocator, num);
//     }

//     return list;
// }
