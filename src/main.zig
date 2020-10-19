const std = @import("std");
const assert = @import("std").debug.assert;

const zfunctions = @import("lib.zig").z_functions;
const Record = @import("lib.zig").record.Record;
const z_ascii = @import("lib.zig").z_ascii;

const c = @cImport({
    @cInclude("src/lib/c_ascii.h");
});
const mem = std.mem;
const fmt = std.fmt;

fn receive_string(s: []const u8) void {
    std.debug.warn("\nThis string was passed into receive_string {}\n", .{s});
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
        std.debug.warn("Get here only if no error\n", .{});
    } else |err| switch (err) {
        error.DestTooSmall =>  {
            std.debug.warn("Got a DestTooSmall error {}\n", .{err});
        },
        else => {
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
        std.debug.warn("Got an error from c_toupper\n", .{});
    } else {
        std.debug.warn("NO error from c_toupper\n", .{});
        // var x1 = out_slice.len;
        // the double meaning of the return value from c_toupper() causes the need for the
        // @intCast in the next statement
        var result = out_str[0..@intCast(usize, uc_len)];
    }
}

pub fn main() void 
{
    // note putting the c_functions_version() call in the print statement like so
    // std.debug.warn("main - using c_functions version {}\n", .{c_functions_version()}")
    // prints the pointer value not the string value
    var vers: [*:0]const u8 = c.c_functions_version();
    std.debug.warn("Main - using c_functions version {}\n", .{vers});

    demo_zig_toupper_with_error_checking(100);
    demo_zig_toupper_with_error_checking(10);
    demo_c_toupper_with_error_checking(100);
    demo_c_toupper_with_error_checking(10);

    var tst = Record.init("hello this is the world");
    std.debug.warn("tst.name is : {}\n", .{tst.name});
    tst.toupper_name();
    std.debug.warn("tst.name is : {}\n", .{tst.name});

}