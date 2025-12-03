const std = @import("std");

pub var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = gpa_impl.allocator();

/// Wraps a number around as if by modulo, but works for negative numbers.
pub fn wrapAround(num: i32, wrapTo: i32) i32 {
    return @mod(@mod(num, wrapTo) + wrapTo, wrapTo);
}

/// Gets an iterator which breaks the input up into lines and returns each line.
pub fn getLines(input: []const u8) std.mem.TokenIterator(u8, .scalar) {
    return std.mem.tokenizeScalar(u8, input, '\n');
}
