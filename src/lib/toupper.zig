const std = @import("std");
const assert = @import("std").debug.assert;


/// The type of error returned by z_toupper if the buffer 
/// is too small
pub const ToUpperError = error {
    DestTooSmall,
};
///
/// performs a to uppercase conversion on a []const u8 entirely in zig
/// returns the converted array as a slice of the passed in buffer
/// returns error.ToUpperError.DestTooSmall if the buffer is too small
///
pub fn z_toupper(in_str: []const u8, buf: []u8) ToUpperError ! []u8 {
    if (in_str.len > buf.len) {
        return error.DestTooSmall;
    }
    var i: usize = 0;
    while (i < in_str.len) {
        var ch = in_str[i];
        if (std.ascii.isASCII(ch)) {
            buf[i] = std.ascii.toUpper(ch);
        } else {
            buf[i] = ch;
        }
        i = i + 1;
    }
    var res = buf[0..in_str.len];
    return res;
}
///
/// This function makes use of a comptime argument in order to be able to make the
/// buffer size parametrizable.
///
/// Also demonstrates error handling 
///
pub fn demo_zig_toupper_with_error_checking(comptime bufsize: usize) void {
    var in_str: []const u8 = "abcedfghijkl";

    // deliberately make a buffer too small
    const buf_len = bufsize;
    var out_str = [_]u8{0} ** bufsize;
    var slice = out_str[0..bufsize];
    var x = slice.len;
    if (z_toupper_3(in_str, slice)) |y| {
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
