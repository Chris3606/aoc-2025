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

fn get_max_digit(line: []const u8) usize {
    var max: u8 = 0;
    var max_idx: usize = 0;
    for (line, 0..) |digit, idx| {
        const numerical_value = digit - '1' + 1;
        if (numerical_value > max) {
            max = numerical_value;
            max_idx = idx;
        }
    }

    return max_idx;
}

fn find_max_joltage(gpa: std.mem.Allocator, battery_bank: []const u8, num_batteries: u32) !u64 {
    var digits: std.ArrayList(u8) = .empty;
    defer digits.deinit(gpa);

    var batteries_remaining = num_batteries;
    var current_selection = battery_bank;
    while (batteries_remaining > 0) : (batteries_remaining -= 1) {
        // Find largest digits, left to right (so highest place value to lowest).  We must restrict
        // each selection to only the digits which leave at least batteries_remaining digits after; otherwise,
        // we'd be missing a digit somewhere down the road. By definition, this would left-pad the resulting number
        // with 0's, which MUST be a lowest number than any number with all of the digits non-zero.
        const max_digit_idx = get_max_digit(
            current_selection[0 .. current_selection.len - batteries_remaining + 1],
        );
        try digits.append(gpa, current_selection[max_digit_idx]);

        // The next digits must come _after_ the one we just selected, since we can't re-order.
        current_selection = current_selection[max_digit_idx + 1 ..];
    }

    return try std.fmt.parseInt(u64, digits.items, 10);
}

fn sum_max_joltage(gpa: std.mem.Allocator, battery_banks: []const []const u8, num_batteries_per_bank: u32) !u64 {
    var result: u64 = 0;
    for (battery_banks) |line| {
        result += try find_max_joltage(gpa, line, num_batteries_per_bank);
    }

    return result;
}

fn part1(gpa: std.mem.Allocator, input: InputType) !u64 {
    return try sum_max_joltage(gpa, input, 2);
}

fn part2(gpa: std.mem.Allocator, input: InputType) !u64 {
    return try sum_max_joltage(gpa, input, 12);
}

pub fn main() !void {
    defer {
        const status = util.gpa_impl.deinit();
        std.debug.assert(status != .leak);
    }
    const input = try parseInput(util.gpa, data);
    defer util.gpa.free(input);

    std.debug.print("Part 1: {d}\n", .{try part1(util.gpa, input)});
    std.debug.print("Part 2: {d}\n", .{try part2(util.gpa, input)});
}

test "day3_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(357, try part1(std.testing.allocator, input));
}

test "day3_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(3121910778619, try part2(std.testing.allocator, input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
