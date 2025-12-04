const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day04.txt");
const sample_data = @embedFile("data/day04_sample.txt");

const InputType = util.SliceView(u8);

const parseInput = util.parseSliceViewFromCharGrid;

fn part1(gpa: std.mem.Allocator, input: InputType) !u32 {
    _ = gpa;
    var result: u32 = 0;

    // std.debug.print("\n", .{});
    // var y: u32 = 0;
    // while (y < input.height()) : (y += 1) {
    //     var x: u32 = 0;
    //     while (x < input.width()) : (x += 1) {
    //         std.debug.print("{c}", .{input.getValueXY(@intCast(x), @intCast(y))});
    //     }
    //     std.debug.print("\n", .{});
    // }

    var pos_it = input.positions();

    while (pos_it.next()) |pos| {
        if (input.getValuePoint(pos) != '@') continue;

        var surrounding_rolls: u32 = 0;
        for (util.Direction.eightWay) |dir| {
            const neighbor = pos.addDirection(dir);
            if (!input.contains(neighbor)) continue;

            if (input.getValuePoint(neighbor) == '@') surrounding_rolls += 1;
        }

        if (surrounding_rolls < 4) {
            result += 1;
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
    defer input.deinit();

    std.debug.print("Part 1: {d}\n", .{try part1(util.gpa, input)});
    std.debug.print("Part 2: {d}\n", .{try part2(util.gpa, input)});
}

test "day04_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit();
    try std.testing.expectEqual(13, try part1(std.testing.allocator, input));
}

test "day04_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit();
    try std.testing.expectEqual(0, try part2(std.testing.allocator, input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
