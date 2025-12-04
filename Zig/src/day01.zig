const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day01.txt");
const sample_data = @embedFile("data/day01_sample.txt");

const Instruction = union(enum) {
    const Self = @This();

    left: i32,
    right: i32,

    pub fn initFromSerialized(string: []const u8) !Self {
        if (string.len < 2) {
            return util.ParsingError.InvalidData;
        }

        const value = try std.fmt.parseInt(i32, string[1..], 10);
        return switch (string[0]) {
            'L' => Self{ .left = value },
            'R' => Self{ .right = value },
            else => util.ParsingError.InvalidData,
        };
    }

    pub fn shifts(self: Self) i32 {
        return switch (self) {
            .left => |val| -val,
            .right => |val| val,
        };
    }
};

const InputType = []const Instruction;
const max_number = 99;

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var vec: std.ArrayList(Instruction) = .empty;
    defer vec.deinit(gpa);

    var input_it = util.tokenizeLines(input_data);
    while (input_it.next()) |line| {
        try vec.append(gpa, try Instruction.initFromSerialized(line));
    }

    return vec.toOwnedSlice(gpa) catch unreachable;
}

fn part1(input: InputType) !u32 {
    var current_value: i32 = 50;
    var times_landed_on_zero: u32 = 0;
    for (input) |instruction| {
        current_value = @mod(current_value + instruction.shifts(), max_number + 1);
        if (current_value == 0) {
            times_landed_on_zero += 1;
        }
    }
    return times_landed_on_zero;
}

fn part2(input: InputType) !u32 {
    var current_value: i32 = 50;
    var times_passed_zero: u32 = 0;
    for (input) |instruction| {
        const shifts = instruction.shifts();

        // Count full wraps
        times_passed_zero += @divTrunc(@abs(shifts), max_number + 1);

        // Update value
        const old_current = current_value;
        current_value = @mod(current_value + shifts, max_number + 1);

        // Find if we passed zero in a partial wrap; if we're on 0, that's captured later
        if (old_current != 0 and current_value != 0) {
            if ((shifts < 0 and current_value > old_current) or (shifts > 0) and current_value < old_current) {
                times_passed_zero += 1; // Wrapped on a final remainder of shifts <= max_number
            }
        }

        // Also if we're on zero, obviously we're at 0
        if (current_value == 0) {
            times_passed_zero += 1;
        }
    }
    return times_passed_zero;
}

pub fn main() !void {
    defer {
        const status = util.gpa_impl.deinit();
        std.debug.assert(status != .leak);
    }
    const input = try parseInput(util.gpa, data);
    defer util.gpa.free(input);

    std.debug.print("Part 1: {d}\n", .{try part1(input)});
    std.debug.print("Part 2: {d}\n", .{try part2(input)});
}

test "day1_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);

    try std.testing.expectEqual(3, try part1(input));
}

test "day1_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);

    try std.testing.expectEqual(6, try part2(input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
