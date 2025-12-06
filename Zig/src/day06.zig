const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day06.txt");
const sample_data = @embedFile("data/day06_sample.txt");

const Operation = enum { add, multiply };

const Problem = struct {
    const Self = @This();

    numbers: std.ArrayList(u32) = .empty,
    operation: Operation = Operation.add,

    fn deinit(self: *Self, gpa: std.mem.Allocator) void {
        self.numbers.deinit(gpa);
    }

    fn evaluate(self: *const Self) u64 {
        switch (self.operation) {
            .add => {
                var initial_val: u64 = 0;
                for (self.numbers.items) |num| {
                    initial_val += @intCast(num);
                }
                return initial_val;
            },
            .multiply => {
                var initial_val: u64 = 1;
                for (self.numbers.items) |num| {
                    initial_val *= @intCast(num);
                }
                return initial_val;
            },
        }
    }
};

const InputType = []Problem;

fn tokensToSlice(comptime T: type, gpa: std.mem.Allocator, buffer: []const T, delimiter: T) ![][]const T {
    var entries: std.ArrayList([]const T) = .empty;
    defer entries.deinit(gpa);

    var it = std.mem.tokenizeScalar(T, buffer, delimiter);

    while (it.next()) |token| {
        try entries.append(gpa, token);
    }

    return entries.toOwnedSlice(gpa) catch unreachable;
}

fn parseInputPt1(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var it = util.tokenizeLines(input_data);

    var problems: std.ArrayList(Problem) = .empty;
    defer problems.deinit(gpa);

    while (it.next()) |line| {
        const line_data = try tokensToSlice(u8, gpa, line, ' ');
        defer gpa.free(line_data);

        if (problems.items.len == 0) {
            for (line_data) |_| {
                try problems.append(gpa, .{});
            }
        }

        if (line_data[0][0] != '*' and line_data[0][0] != '+') {
            for (line_data, 0..) |itm, i| {
                try problems.items[i].numbers.append(
                    gpa,
                    try std.fmt.parseInt(u32, itm, 10),
                );
            }
        } else {
            for (line_data, 0..) |itm, i| {
                problems.items[i].operation = switch (itm[0]) {
                    '+' => Operation.add,
                    '*' => Operation.multiply,
                    else => return util.ParsingError.InvalidData,
                };
            }
        }
    }

    return problems.toOwnedSlice(gpa) catch unreachable;
}

fn parseInputPt2(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var view = try util.parseSliceViewFromCharGrid(gpa, input_data);
    defer view.deinit();

    var problems: std.ArrayList(Problem) = .empty;
    defer problems.deinit(gpa);

    // Iterate over grid and create problems
    var cur_x: i32 = 0;
    const operator_y: i32 = @intCast(view.height() - 1);

    while (cur_x < view.width()) {
        const operator = view.getValueXY(cur_x, operator_y);
        if (operator != '*' and operator != '+') return util.ParsingError.InvalidData;

        var problem = Problem{};
        errdefer problem.deinit(gpa);

        // Loop down y-lines until we find one with no digits
        while (cur_x < view.width()) : (cur_x += 1) {
            // Each y-line is a number, digits top to bottom.
            var digits: std.ArrayList(u8) = .empty;
            defer digits.deinit(gpa);

            var cur_y: i32 = 0;
            while (cur_y < view.height() - 1) : (cur_y += 1) {
                const digit = view.getValueXY(cur_x, cur_y);
                if (digit != ' ') {
                    try digits.append(gpa, digit);
                }
            }

            if (digits.items.len != 0) {
                const number = try std.fmt.parseInt(u32, digits.items, 10);
                try problem.numbers.append(gpa, number);
            } else {
                cur_x += 1;
                break;
            }
        }

        problem.operation = switch (operator) {
            '+' => .add,
            '*' => .multiply,
            else => return util.ParsingError.InvalidData,
        };
        try problems.append(gpa, problem);
    }

    return problems.toOwnedSlice(gpa) catch unreachable;
}

fn printProblems(problems: []const Problem) void {
    for (problems) |prob| {
        for (prob.numbers.items) |num| {
            std.debug.print("{} ", .{num});
        }

        std.debug.print("\n{}\n\n", .{prob.operation});
    }
}

fn part1(input: InputType) !u64 {
    var result: u64 = 0;

    for (input) |prob| {
        result += prob.evaluate();
    }

    return result;
}

fn part2(input: InputType) !u64 {
    var result: u64 = 0;

    for (input) |prob| {
        result += prob.evaluate();
    }

    return result;
}

pub fn main() !void {
    defer {
        const status = util.gpa_impl.deinit();
        std.debug.assert(status != .leak);
    }
    const input1 = try parseInputPt1(util.gpa, data);
    defer {
        for (input1) |*prob| {
            prob.deinit(util.gpa);
        }
        util.gpa.free(input1);
    }

    const input2 = try parseInputPt2(util.gpa, data);
    defer {
        for (input2) |*prob| {
            prob.deinit(util.gpa);
        }
        util.gpa.free(input2);
    }

    std.debug.print("Part 1: {d}\n", .{try part1(input1)});
    std.debug.print("Part 2: {d}\n", .{try part2(input2)});
}

test "day06_part1" {
    const input = try parseInputPt1(std.testing.allocator, sample_data);
    defer {
        for (input) |*prob| {
            prob.deinit(std.testing.allocator);
        }
        std.testing.allocator.free(input);
    }

    try std.testing.expectEqual(4277556, try part1(input));
}

test "day06_part2" {
    const input = try parseInputPt2(std.testing.allocator, sample_data);
    defer {
        for (input) |*prob| {
            prob.deinit(std.testing.allocator);
        }
        std.testing.allocator.free(input);
    }
    try std.testing.expectEqual(3263827, try part2(input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
