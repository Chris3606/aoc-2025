const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day01.txt");

fn wrapAround(num: i32, wrapTo: i32) i32 {
    return @mod(@mod(num, wrapTo) + wrapTo, wrapTo);
}

pub fn main() !void {
    var seq = std.mem.tokenizeScalar(u8, data, '\n');

    var val: i32 = 50;
    var times_at_zero: u32 = 0;
    var times_passing_zero: u32 = 0;
    while (seq.next()) |line| {
        var turns = try std.fmt.parseInt(i32, line[1..], 10);
        while (turns > 0) : (turns -= 1) {
            if (line[0] == 'L') {
                val -= 1;
                if (val < 0) {
                    val = 99;
                }
            } else {
                val += 1;
                if (val > 99) {
                    val = 0;
                }
            }

            if (val == 0) {
                times_passing_zero += 1;
            }
        }

        // times_passing_zero += @abs(@divTrunc((turns + val), 100));
        // val = wrapAround(val + turns, 100);
        if (val == 0) {
            times_at_zero += 1;
        }
    }
    std.debug.print("Part 1: {d}\n", .{times_at_zero});
    std.debug.print("Part 2: {d}\n", .{times_passing_zero});
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
