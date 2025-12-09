const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day08.txt");
const sample_data = @embedFile("data/day08_sample.txt");

const InputType = []util.Point3d;

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var vec: std.ArrayList(util.Point3d) = .empty;
    defer vec.deinit(gpa);

    var input_it = util.tokenizeLines(input_data);
    while (input_it.next()) |line| {
        try vec.append(gpa, try util.Point3d.initFromSerialized(line));
    }

    return vec.toOwnedSlice(gpa) catch unreachable;
}

const PointPair = struct {
    p1: util.Point3d,
    p2: util.Point3d,
    dist: f64,
};

fn pointPairSorter(_: void, a: PointPair, b: PointPair) bool {
    return a.dist < b.dist;
}

fn part1(gpa: std.mem.Allocator, input: InputType) !u64 {
    var result: u64 = 0;

    for (input) |pos| {
        std.debug.print("{},{},{}\n", .{ pos.x, pos.y, pos.z });
    }

    var xBound: u32 = 0;
    var yBound: u32 = 0;
    var zBound: u32 = 0;

    for (input) |pos| {
        xBound = @max(xBound, pos.x);
        yBound = @max(yBound, pos.x);
        zBound = @max(zBound, pos.x);
    }

    var pairs: std.ArrayList(PointPair) = .empty;
    defer pairs.deinit(gpa);

    for (input, 0..) |pos, idx| {
        for (input[idx..]) |pos2| {
            try pairs.append(gpa, PointPair{
                .p1 = pos,
                .p2 = pos2,
                .dist = pos.straight_line_dist(&pos2),
            });
        }
    }

    std.mem.sort(PointPair, pairs.items, {}, pointPairSorter);

    var sets: std.ArrayList(std.DynamicBitSet) = .empty;
    defer {
        for (sets.items) |*set| {
            set.deinit();
        }
        sets.deinit(gpa);
    }

    var s = try std.DynamicBitSet.initEmpty(xBound * yBound * zBound);

    var processed_pairs: usize = 0;
    for (pairs.items) |pair| {

        // Break after x connections
        processed_pairs += 1;
        if (processed_pairs == 10) {
            break;
        }
    }

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

test "day08_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(0, try part1(std.testing.allocator, input));
}

test "day08_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);
    try std.testing.expectEqual(0, try part2(std.testing.allocator, input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
