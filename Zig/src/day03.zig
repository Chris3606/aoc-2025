const std = @import("std");
const util = @import("util.zig");

const data = @embedFile("data/day03.txt");
const sample_data = @embedFile("data/day03_sample.txt");

const InputType = [][]const u8;

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var vec: std.ArrayList([]const u8) = .empty;
    defer vec.deinit(gpa);

    var it = util.getLines(input_data);
    while (it.next()) |line| {
        try vec.append(gpa, line);
    }

    return vec.toOwnedSlice(gpa) catch unreachable;
}

fn get_max_digit(line: []const u8, exclude_index: usize) usize {
    var max: u8 = 0;
    var max_idx: usize = 0;
    for (line, 0..) |digit, idx| {
        if (idx == exclude_index) continue;
        const numerical_value = digit - '1' + 1;
        if (numerical_value > max) {
            max = numerical_value;
            max_idx = idx;
        }
    }

    return max_idx;
}

fn part1(input: InputType) !u32 {
    var result: u32 = 0;
    for (input) |line| {
        // Find largest 10s place; it can't be the last because there would be no ones place
        // so any number with a 10s place would be trivially larger
        const tens = get_max_digit(line, line.len - 1);

        // Biggest one after it is that digit
        const remaining = line[tens + 1 ..];
        const ones = get_max_digit(remaining, remaining.len);

        const digits = [2]u8{ line[tens], remaining[ones] };
        result += try std.fmt.parseInt(u8, &digits, 10);
    }

    return result;
}

fn part2(input: InputType) !u32 {
    _ = input;

    return 0;
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

test "day3_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(357, try part1(input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
