const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day05.txt");
const sample_data = @embedFile("data/day05_sample.txt");

const InputType = struct {
    const Self = @This();

    fresh_ranges: []util.Range,
    available_ids: []i64,

    pub fn deinit(self: *const Self, gpa: std.mem.Allocator) void {
        gpa.free(self.fresh_ranges);
        gpa.free(self.available_ids);
    }
};

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var it = std.mem.tokenizeSequence(u8, input_data, "\n\n");
    const fresh_ranges_data = it.next() orelse return util.ParsingError.InvalidData;
    const available_ids_data = it.next() orelse return util.ParsingError.InvalidData;

    const ranges = try util.parseRangeList(gpa, fresh_ranges_data, '\n');
    const available_ids = try util.parseIntList(i64, gpa, available_ids_data, '\n');

    return .{ .fresh_ranges = ranges, .available_ids = available_ids };
}

fn part1(input: InputType) !u64 {
    var result: u64 = 0;

    for (input.available_ids) |id| {
        const is_fresh = blk: for (input.fresh_ranges) |range| {
            if (range.containsValue(id)) break :blk true;
        } else break :blk false;

        if (is_fresh) {
            result += 1;
        }
    }

    return result;
}

fn rangeSorter(_: void, a: util.Range, b: util.Range) bool {
    if (a.begin == b.begin) return a.end < b.end;
    return a.begin < b.begin;
}

fn part2(input: InputType) !u64 {
    var result: u64 = 0;

    // Tricky problem statement; one way to do this is to merge the ranges into unique ranges then count.
    // But you don't actually have to; you can simply sort the ranges by begin (then by end), and track
    // what the max you've seen is to know whether there is any overlap.
    std.mem.sort(util.Range, input.fresh_ranges, {}, rangeSorter);

    var max_seen: u64 = 0;

    for (input.fresh_ranges) |range| {
        if (range.begin > max_seen) {
            result += range.numValues();
        } else if (range.end > max_seen) {
            result += @as(u64, @intCast(range.end)) - max_seen;
        }
        max_seen = @max(max_seen, range.end);
    }

    return result;
}

pub fn main() !void {
    defer {
        const status = util.gpa_impl.deinit();
        std.debug.assert(status != .leak);
    }
    const input = try parseInput(util.gpa, data);
    defer input.deinit(util.gpa);

    std.debug.print("Part 1: {d}\n", .{try part1(input)});
    std.debug.print("Part 2: {d}\n", .{try part2(input)});
}

test "day05_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit(std.testing.allocator);
    try std.testing.expectEqual(3, try part1(input));
}

test "day05_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit(std.testing.allocator);
    try std.testing.expectEqual(14, try part2(input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
