const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day04.txt");
const sample_data = @embedFile("data/day04_sample.txt");

const InputType = util.SliceView(u8);

const parseInput = util.parseSliceViewFromCharGrid;

fn removePaper(comptime TContext: type, gpa: std.mem.Allocator, map: *util.SettableGridView(TContext, u8)) !u32 {
    var rolls_removed: u32 = 0;
    var pos_it = map.positions();

    var positions_removed: std.ArrayList(util.Point) = .empty;
    defer positions_removed.deinit(gpa);

    while (pos_it.next()) |pos| {
        if (map.getValuePoint(pos) != '@') continue;

        var surrounding_rolls: u32 = 0;
        for (util.Direction.eightWay) |dir| {
            const neighbor = pos.addDirection(dir);
            if (!map.contains(neighbor)) continue;

            if (map.getValuePoint(neighbor) == '@') surrounding_rolls += 1;
        }

        if (surrounding_rolls < 4) {
            rolls_removed += 1;
            try positions_removed.append(gpa, pos);
        }
    }

    for (positions_removed.items) |pos| {
        map.setValuePoint(pos, '.');
    }

    return rolls_removed;
}

fn part1(gpa: std.mem.Allocator, input: *InputType) !u32 {
    return try removePaper(util.SliceViewContext(u8), gpa, input);
}

fn part2(gpa: std.mem.Allocator, input: *InputType) !u32 {
    var result: u32 = 0;

    var removed: u32 = 1; // Non-zero to force first iteration
    while (removed != 0) {
        removed = try removePaper(util.SliceViewContext(u8), gpa, input);
        result += removed;
    }

    return result;
}

pub fn main() !void {
    defer {
        const status = util.gpa_impl.deinit();
        std.debug.assert(status != .leak);
    }
    var input = try parseInput(util.gpa, data);
    defer input.deinit();

    std.debug.print("Part 1: {d}\n", .{try part1(util.gpa, &input)});

    input.deinit();
    input = try parseInput(util.gpa, data);
    std.debug.print("Part 2: {d}\n", .{try part2(util.gpa, &input)});
}

test "day04_part1" {
    var input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit();
    try std.testing.expectEqual(13, try part1(std.testing.allocator, &input));
}

test "day04_part2" {
    var input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit();
    try std.testing.expectEqual(43, try part2(std.testing.allocator, &input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
