const std = @import("std");

const util = @import("util.zig");

const data = @embedFile("data/day01.txt");
const InputType = std.ArrayList(struct { i8, i32 });
const max_number = 99;

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) !InputType {
    var vec: InputType = .empty;
    errdefer vec.deinit(gpa);

    var input_it = util.getLines(input_data);
    while (input_it.next()) |line| {
        try vec.append(
            gpa,
            .{
                if (line[0] == 'L') -1 else 1,
                try std.fmt.parseInt(i32, line[1..], 10),
            },
        );
    }

    return vec;
}

fn part1(input: InputType) !u32 {
    var current_value: i32 = 50;
    var times_landed_on_zero: u32 = 0;
    for (input.items) |instruction| {
        const shifts = instruction[1] * instruction[0];
        current_value = util.wrapAround(current_value + shifts, max_number + 1);
        if (current_value == 0) {
            times_landed_on_zero += 1;
        }
    }
    return times_landed_on_zero;
}

fn part2(input: InputType) !u32 {
    var current_value: i32 = 50;
    var times_passed_zero: u32 = 0;
    for (input.items) |instruction| {
        const shifts = instruction[1] * instruction[0];

        // Count full wraps
        times_passed_zero += @divTrunc(@abs(shifts), max_number + 1);

        // Update value
        const old_current = current_value;
        current_value = util.wrapAround(current_value + shifts, max_number + 1);

        // Find if we passed zero in a partial wrap; if we're on 0, that's captured later
        if (old_current != 0 and current_value != 0) {
            if ((shifts < 0 and current_value > old_current) or (shifts > 0) and current_value < old_current) {
                times_passed_zero += 1; // Wrapped on a final remainder of shifts <= max_number
            }
        }

        // Also if we're on zero, obviously we're at 0
        if (current_value == 0) {
            times_passed_zero += 1;
        }
    }
    return times_passed_zero;
}

pub fn main() !void {
    defer {
        const status = util.gpa_impl.deinit();
        std.debug.assert(status != .leak);
    }
    var input = try parseInput(util.gpa, data);
    defer input.deinit(util.gpa);

    std.debug.print("Part 1: {d}\n", .{try part1(input)});
    std.debug.print("Part 1: {d}\n", .{try part2(input)});
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
