const std = @import("std");
const expect = @import("std").testing.expect;
const vector = @import("../src/vector")

test "function" {
    const y = addFive(0);
    expect(@TypeOf(y) == u32);
    expect(y == 5);
}

