const std = @import("std");
const assert = @import("std").debug.assert;

const zfunctions = @import("lib.zig").zfunctions;
const Record = @import("lib.zig").record.Record;
const ztoupper = @import("lib.zig").ztoupper;

const c = @cImport({
    @cInclude("src/lib/c_functions.h");
});
const mem = std.mem;
const fmt = std.fmt;

fn receive_string(s: []const u8) void {
    std.debug.warn("\nThis string was passed into receive_string {}\n", .{s});
}

pub fn toup_1() void {
    // an investigation into c_strings, arrays and slices
    var out_str = [_]u8{0} ** 100;
    out_str[99] = 0;
    var out_slice = out_str[0..99];
    var out_ptr = &out_slice[0];
    _ = c.c_toupper("abcdefghij", out_ptr, out_slice.len);
    var x1 = out_slice.len;
    assert(out_slice.len == 99); // this is not the desired result - would want this to be 10
}

pub fn toup_2() void {
    // create a string to be uppercased - zig expects utf8 for strings - but since
    // this is usiing c under the covers really expect ascii
    var in_str: [*:0]const u8 = "abcedfghijkl";

    // now create a buffer for the uppercased string
    const buf_len = 100;
    var out_str = [_]u8{0} ** buf_len;
    out_str[99] = 0;
    var out_slice = out_str[0..99];
    var out_ptr = &out_slice[0];
    var uc_len = c.c_toupper(in_str, out_ptr, out_slice.len);
    var x1 = out_slice.len;
    var result = out_slice[0..uc_len];
    assert(result.len == uc_len);
    assert(uc_len == 12);
    assert(out_slice.len == 99); // this is not the desired result - would want this to be 10
}

pub fn toup_3() void {
    // create a string to be uppercased - zig expects utf8 for strings - but since
    // this is usiing c under the covers really expect ascii
    var in_str: [*:0]const u8 = "abcedfghijkl";

    // now create a buffer for the uppercased string
    const buf_len = 100;
    var out_str = [_]u8{0} ** buf_len;

    // this is more C like
    var uc_len = c.c_toupper(in_str, &out_str, buf_len);
    var result = out_str[0..uc_len];
    assert(result.len == uc_len);
    assert(uc_len == 12);
}

pub fn z_toupper(in_str: [*:0]const u8, buf: []u8) void {
    var uc_len = c.c_toupper(in_str, buf.ptr, @intCast(c_uint, buf.len));
}

pub fn toup_4() void {
    var in_str: [*:0]const u8 = "abcedfghijkl";
    const buf_len = 100;
    var out_str = [_]u8{0} ** buf_len;
    var slice = out_str[0..100];
    var x = slice.len;
    z_toupper(in_str, slice);
    // slice len is still not updated
}


pub fn z_toupper_2(in_str: [*:0]const u8, buf: []u8) []u8 {
    var uc_len = c.c_toupper(in_str, buf.ptr, @intCast(c_uint, buf.len));
    var res = buf[0..uc_len];
    return res;
}

pub fn toup_5() void {
    var in_str: [*:0]const u8 = "abcedfghijkl";
    const buf_len = 100;
    var out_str = [_]u8{0} ** buf_len;
    var slice = out_str[0..100];
    var x = slice.len;
    var y = z_toupper_2(in_str, slice);
    // slice len is still not updated
}

pub fn main() void 
{
    std.debug.warn("main - to prove its the lib version", .{});
    c.c_test_func("Hello - to prove its the lib version");

    toup_1();
    toup_2();
    toup_3();
    toup_4();
    toup_5();
    ztoupper.demo_zig_toupper_with_error_checking(100);
    ztoupper.demo_zig_toupper_with_error_checking(10);


    var i: u32 = 3;
    std.debug.warn("Here we are\n", .{});
    var x = "0123456789";
    var slice = x[0..];
    var tst = Record.init("hello this is the world");
    std.debug.warn("tst.name is : {}\n", .{tst.name});
    var buffer: [100]u8 = undefined;
    var buffer_slice: []u8 = buffer[0..];
    // String concatenation example.
    var y = x.len;
    var a1 = zfunctions.add_i32(7, 8);
    var a2 = zfunctions.mult_8(3);
    std.debug.warn("a1 = {} a2 = {}\n", .{a1, a2});
    receive_string(x);
}