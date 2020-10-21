const std = @import("std");
const expect = @import("std").testing.expect;

test "function" {
    std.debug.warn("From tests/test_1.zig", .{});
    const y = 5;
    expect(y == 5);
}

