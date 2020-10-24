const std = @import("std");
const assert = std.debug.assert;
const c = @cImport({
    // note this is relative to project dir
    @cInclude("src/c_ascii.h");
    @cInclude("string.h");
});

const z_ascii = @import("ascii.zig");

pub fn test_string_copy() void {
    var s = "thisisastring";
    var buf:[100]u8 = [_]u8{0} ** 100;
    // testing the principles of copy
    for (s) |ch, i| {
        buf[i] = s[i];
    }
    var slice1 = buf[0..s.len];

    for(s) |ch, i| {
        std.debug.assert(s[i] == buf[i]);
    }
    // now test the cpy function
    var buf2:[100]u8 = [_]u8{0} ** 100;
    var bufslice = buf2[0..100];
    var res_slice = z_ascii.z_cpy(bufslice, slice1);
    var b = z_ascii.z_streq(res_slice, slice1);
    std.debug.assert(b);
}
///
/// This function makes use of a comptime argument in order to be able to make the
/// buffer size parametrizable.
///
/// Also demonstrates error handling in the zig world
///
pub fn demo_zig_toupper_with_error_checking(comptime bufsize: usize) void {
    var in_str: []const u8 = "abcedfghijkl";

    // deliberately make a buffer too small
    const buf_len = bufsize;
    var out_str = [_]u8{0} ** bufsize;
    var slice = out_str[0..bufsize];
    var x = slice.len;
    if (z_ascii.z_toupper(in_str, slice)) |y| {
        // var res = slice[0..y];
        assert(buf_len >= in_str.len);
        var r = z_ascii.z_streq("ABCDEFGHIJ", y);
        std.debug.warn("Get here only if no error\n", .{});
    } else |err| switch (err) {
        error.DestTooSmall =>  {
            assert(buf_len < in_str.len);
            std.debug.warn("Got a DestTooSmall error {}\n", .{err});
        },
        else => {
            assert(false);
            std.debug.warn("Got an unknown error {}\n", .{err});
        }
    }
}
///
/// This function makes use of a comptime argument in order to be able to make the
/// buffer size parametrizable.
///
/// Also demonstrates error handling in the c world
///
pub fn demo_c_toupper_with_error_checking(comptime bufsize: usize) void {
    // an investigation into c_strings, arrays and slices
    var in_str: [*:0]const u8 = "abcedfghijkl";

    // note the use of a libc function
    var in_len = c.strlen(in_str);
    
    // make a buffer and get a ptr to the start of it
    var out_str = [_]u8{0} ** bufsize;
    var out_ptr = &out_str[0];
    //
    // Notice the different c interface as we have to pass buffer ptr and buffer len separately
    //
    var uc_len = c.c_toupper(in_str, out_ptr, bufsize);
    //
    // Not to mention the different error treatment via two different interpretations
    // of the return value
    //
    if (uc_len < 0) {
        std.debug.assert(bufsize < in_len);
        std.debug.warn("Got an error from c_toupper\n", .{});
    } else {
        std.debug.assert(bufsize >= in_len);
        std.debug.warn("NO error from c_toupper\n", .{});
        // var x1 = out_slice.len;
        // the double meaning of the return value from c_toupper() causes the need for the
        // @intCast in the next statement
        var result = out_str[0..@intCast(usize, uc_len)];
    }
}
pub fn tests() void {
    demo_zig_toupper_with_error_checking(100);
    demo_zig_toupper_with_error_checking(10);
    demo_c_toupper_with_error_checking(100);
    demo_c_toupper_with_error_checking(10);
    test_string_copy();
}