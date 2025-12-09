const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day09.txt");
const sample_data = @embedFile("data/day09_sample.txt");

const InputType = []util.Point;

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var it = util.tokenizeLines(input_data);
    var list: std.ArrayList(util.Point) = .empty;
    defer list.deinit(gpa);

    while (it.next()) |line| {
        var parts = std.mem.tokenizeScalar(u8, line, ',');

        const x_data = parts.next() orelse return util.ParsingError.InvalidData;
        const y_data = parts.next() orelse return util.ParsingError.InvalidData;
        try list.append(gpa, util.Point{
            .x = try std.fmt.parseInt(i32, x_data, 10),
            .y = try std.fmt.parseInt(i32, y_data, 10),
        });
    }
    return list.toOwnedSlice(gpa) catch unreachable;
}

fn part1(gpa: std.mem.Allocator, input: InputType) !u64 {
    _ = gpa;
    var result: u64 = 0;

    for (input, 0..) |p1, idx| {
        var j: usize = idx + 1;
        while (j < input.len) : (j += 1) {
            const p2 = input[j];
            const area = (@as(u64, @abs(p2.x - p1.x)) + 1) * (@as(u64, @abs(p2.y - p1.y)) + 1);
            result = @max(result, area);
        }
    }

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

test "day09_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(50, try part1(std.testing.allocator, input));
}

test "day09_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(0, try part2(std.testing.allocator, input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
