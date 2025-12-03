const std = @import("std");

const util = @import("util.zig");

const sample_data = @embedFile("data/day02_sample.txt");
const data = @embedFile("data/day02.txt");

const ParsingError = error{InvalidData};

const Range = struct {
    const Self = @This();

    /// Inclusive
    begin: i64,
    /// Exclusive
    end: i64,

    /// Initializes from data in format [min]-[max] (where max is inclusive)
    pub fn initFromSerialized(string: []const u8) !Self {
        var it = std.mem.tokenizeScalar(u8, string, '-');
        const min = try (it.next() orelse ParsingError.InvalidData);
        const max = try (it.next() orelse ParsingError.InvalidData);

        return Self{
            .begin = try std.fmt.parseInt(i64, min, 10),
            .end = try std.fmt.parseInt(i64, max, 10) + 1,
        };
    }
};

const InputType = []Range;

fn parseInput(gpa: std.mem.Allocator, input_data: []const u8) ![]Range {
    var vec: std.ArrayList(Range) = .empty;
    defer vec.deinit(gpa);

    var it = std.mem.tokenizeScalar(u8, input_data, ',');
    while (it.next()) |range_data| {
        try vec.append(gpa, try Range.initFromSerialized(range_data));
    }

    return vec.toOwnedSlice(gpa) catch unreachable;
}

fn part1(input: []const Range) !u64 {
    var result: u64 = 0;
    var int_buf: [20]u8 = undefined;

    for (input) |range| {
        var num: i64 = range.begin;
        while (num < range.end) : (num += 1) {
            const num_string = try std.fmt.bufPrint(&int_buf, "{d}", .{num});
            if (num_string.len % 2 != 0) {
                continue;
            }

            if (std.mem.eql(u8, num_string[0 .. num_string.len / 2], num_string[num_string.len / 2 ..])) {
                result += @intCast(num);
            }
        }
    }

    return result;
}

fn part2(input: []const Range) !u64 {
    var result: u64 = 0;
    var int_buf: [20]u8 = undefined;

    for (input) |range| {
        var num: i64 = range.begin;
        outer: while (num < range.end) : (num += 1) {
            const num_string = try std.fmt.bufPrint(&int_buf, "{d}", .{num});

            var step: u32 = 1;
            while (step <= num_string.len / 2) : (step += 1) {
                if (num_string.len % step != 0) continue;
                var cur_idx: u32 = step;
                const is_repeated: bool = blk: {
                    while (cur_idx < num_string.len) : (cur_idx += step) {
                        if (!std.mem.eql(u8, num_string[0..step], num_string[cur_idx .. cur_idx + step])) {
                            break :blk false;
                        }
                    } else break :blk true;
                };

                if (is_repeated) {
                    result += @intCast(num);
                    continue :outer;
                }
            }

            if (std.mem.eql(u8, num_string[0 .. num_string.len / 2], num_string[num_string.len / 2 ..])) {
                result += @intCast(num);
            }
        }
    }

    return result;
}

pub fn main() !void {
    defer {
        const status = util.gpa_impl.deinit();
        std.debug.assert(status != .leak);
    }
    const input = try parseInput(util.gpa, data);
    defer util.gpa.free(input);

    std.debug.print("Part 1: {d}\n", .{try part1(input)});
    std.debug.print("Part 2: {d}\n", .{try part2(input)});
}

test "day2_part1" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);

    try std.testing.expectEqual(1227775554, try part1(input));
}

test "day2_part2" {
    const input = try parseInput(std.testing.allocator, sample_data);
    defer std.testing.allocator.free(input);

    try std.testing.expectEqual(4174379265, try part2(input));
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
