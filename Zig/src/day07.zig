const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day07.txt");
const sample_data = @embedFile("data/day07_sample.txt");

const InputContext = util.SliceViewContext(u8);
const InputType = util.SettableGridView(util.SliceViewContext(u8), u8);

const parseInput = util.parseSliceViewFromCharGrid;

fn simulateTachyonBeam(start: util.Point, map: *const util.GridView(InputContext, u8), current_splitters_used: *std.DynamicBitSet) u32 {
    var pos = start;
    while (map.contains(pos)) : (pos = pos.addDirection(util.Direction.Down)) {
        const index = pos.toIndex(map.width());
        if (current_splitters_used.isSet(index)) {
            break; // Already covered by previous tachyons
        }
        current_splitters_used.set(index);
        if (map.getValuePoint(pos) == '^') {
            const left = simulateTachyonBeam(pos.addDirection(util.Direction.Left), map, current_splitters_used);
            const right = simulateTachyonBeam(pos.addDirection(util.Direction.Right), map, current_splitters_used);

            //std.debug.print("From ({},{}), split and left: {}, right: {}\n", .{ pos.x, pos.y, left, right });

            return left + right + 1;
        }
    }

    return 0;
}

fn toState(gpa: std.mem.Allocator, splitters: *std.DynamicBitSet, start: usize) ![]u8 {
    var slice = try gpa.alloc(u8, splitters.count() + 10);
    errdefer gpa.free(slice);

    var x: usize = 0;
    while (x < splitters.count()) : (x += 1) {
        slice[x] = if (splitters.isSet(x)) '1' else '0';
    }

    var i: usize = 0;
    while (i < 10) : (i += 1) {
        slice[i + splitters.count()] = '0';
    }

    _ = try std.fmt.bufPrint(slice[splitters.count()..], "{d}", .{start});

    return slice;
}

fn simulateTachyonBeam2(
    start: util.Point,
    map: *const util.GridView(InputContext, u8),
    current_splitters_used: *std.DynamicBitSet,
    gpa: std.mem.Allocator,
    memo: *std.StringHashMap(u64),
) !u64 {
    const start_index = start.toIndex(map.width());
    {
        const state = try toState(gpa, current_splitters_used, start_index);
        defer gpa.free(state);

        if (memo.contains(state)) {
            return memo.get(state).?;
        }
    }

    var old_state = try current_splitters_used.clone(gpa);
    defer old_state.deinit();

    var pos = start;
    while (map.contains(pos)) : (pos = pos.addDirection(util.Direction.Down)) {
        const index = pos.toIndex(map.width());
        if (current_splitters_used.isSet(index)) {
            break; // Already covered by previous tachyons
        }
        current_splitters_used.set(index);
        if (map.getValuePoint(pos) == '^') {
            //var new_splitters = try current_splitters_used.clone(gpa);
            //defer new_splitters.deinit();

            const lNeighbor = pos.addDirection(util.Direction.Left);
            const lNeighborIndex = lNeighbor.toIndex(map.width());
            const left = blk: {
                if (current_splitters_used.isSet(lNeighborIndex)) {
                    break :blk 0;
                } else {
                    var new_splitters = try current_splitters_used.clone(gpa);
                    defer new_splitters.deinit();
                    break :blk try simulateTachyonBeam2(
                        lNeighbor,
                        map,
                        &new_splitters,
                        gpa,
                        memo,
                    );
                }
            };
            //new_splitters.deinit();
            //new_splitters = try current_splitters_used.clone(gpa);
            //defer new_splitters.deinit();

            const rNeighbor = pos.addDirection(util.Direction.Right);
            const rNeighborIndex = rNeighbor.toIndex(map.width());
            const right = blk: {
                if (current_splitters_used.isSet(rNeighborIndex)) {
                    break :blk 0;
                } else {
                    var new_splitters = try current_splitters_used.clone(gpa);
                    defer new_splitters.deinit();
                    break :blk try simulateTachyonBeam2(
                        rNeighbor,
                        map,
                        &new_splitters,
                        gpa,
                        memo,
                    );
                }
            };

            //current_splitters_used.unset(index);
            //std.debug.print("From ({},{}), split and left: {}, right: {}\n", .{ pos.x, pos.y, left, right });

            const state = try toState(gpa, &old_state, start_index);
            errdefer gpa.free(state);
            try memo.put(state, left + right);
            return left + right;
        }
    }

    const state = try toState(gpa, &old_state, start_index);
    errdefer gpa.free(state);
    try memo.put(state, 1);
    return 1;
}

fn part1(gpa: std.mem.Allocator, input: InputType) !u32 {
    const start = blk: {
        var it = input.positions();

        while (it.next()) |pos| {
            if (input.getValuePoint(pos) == 'S') break :blk pos;
        } else return util.ParsingError.InvalidData;
    };

    var bitSet = try std.DynamicBitSet.initEmpty(gpa, input.numCells());
    defer bitSet.deinit();

    return simulateTachyonBeam(start, &input.basicView, &bitSet);
}

fn part2(gpa: std.mem.Allocator, input: InputType) !u64 {
    const start = blk: {
        var it = input.positions();

        while (it.next()) |pos| {
            if (input.getValuePoint(pos) == 'S') break :blk pos;
        } else return util.ParsingError.InvalidData;
    };

    var bitSet = try std.DynamicBitSet.initEmpty(gpa, input.numCells());
    defer bitSet.deinit();

    var memo = std.StringHashMap(u64).init(gpa);
    defer {
        // var it =
        // while (it.next()) |key| {
        //     gpa.free(*key);
        // }
        // TODO: Fix leak
        memo.deinit();
    }

    return try simulateTachyonBeam2(start, &input.basicView, &bitSet, gpa, &memo);
}

pub fn main() !void {
    // defer {
    //     const status = util.gpa_impl.deinit();
    //     _ = status;
    //     //std.debug.assert(status != .leak);
    // }
    const input = try parseInput(util.gpa, data);
    defer input.deinit();

    std.debug.print("Part 1: {d}\n", .{try part1(util.gpa, input)});
    std.debug.print("Part 2: {d}\n", .{try part2(util.gpa, input)});
}

test "day07_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit();
    try std.testing.expectEqual(21, try part1(std.testing.allocator, input));
}

test "day07_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer input.deinit();
    try std.testing.expectEqual(40, try part2(std.testing.allocator, input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
