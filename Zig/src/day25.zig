const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day25.txt");
const sample_data = @embedFile("data/day25_sample.txt");

const InputType = [][]const u8;

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    _ = gpa;
    _ = input_data;

    return error.NotImplemented;
}

fn part1(gpa: std.mem.Allocator, input: InputType) !u64 {
    _ = gpa;
    _ = input;
    var result: u64 = 0;

    result += 0; // Get compiler to stop complaining about const

    return result;
}

fn part2(gpa: std.mem.Allocator, input: InputType) !u64 {
    _ = gpa;
    _ = input;
    var result: u64 = 0;

    result += 0; // Get compiler to stop complaining about const

    return result;
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

test "day25_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(0, try part1(std.testing.allocator, input));
}

test "day25_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(0, try part2(std.testing.allocator, input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
