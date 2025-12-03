const std = @import("std");

pub var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = gpa_impl.allocator();

/// Wraps a number around as if by modulo, but works for negative numbers.
pub fn wrapAround(num: i32, wrapTo: i32) i32 {
    return @mod(@mod(num, wrapTo) + wrapTo, wrapTo);
}

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
const ParsingError = error{InvalidData};

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
