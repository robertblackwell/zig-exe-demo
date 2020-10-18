const std = @import("std");
const func01 = @import("func01.zig");
const Test = @import("test_struct.zig").Test;
const c = @cImport({
    @cInclude("src/c_test_func.h");
});
const mem = std.mem;
const fmt = std.fmt;

fn receive_string(s: []const u8) void {
    std.debug.warn("\nThis string was passed into receive_string {}\n", .{s});
}

pub fn main() void 
{
    c.c_test_func("Hello");
    var i: u32 = 3;
    std.debug.warn("Here we are\n", .{});
    var x = "0123456789";
    var slice = x[0..];
    var tst = Test.init("hello this is the world");
    std.debug.warn("tst.name is : {}\n", .{tst.name});
    var buffer: [100]u8 = undefined;
    var buffer_slice: []u8 = buffer[0..];
    // String concatenation example.
    var y = x.len;
    var a1 = func01.add_i32(7, 8);
    var a2 = func01.mult_8(3);
    std.debug.warn("a1 = {} a2 = {}\n", .{a1, a2});
    receive_string(x);
}