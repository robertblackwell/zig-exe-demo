///
/// This is a simple zig library for converting the ascii members of a []u8 to
/// upper or lower case
///
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
/// performs a to lowercase conversion on a []const u8 entirely in zig
/// returns the converted array as a slice of the passed in buffer
/// returns error.ToUpperError.DestTooSmall if the buffer is too small
///
pub fn z_tolower(in_str: []const u8, buf: []u8) ToUpperError ! []u8 {
    if (in_str.len > buf.len) {
        return error.DestTooSmall;
    }
    var i: usize = 0;
    while (i < in_str.len) {
        var ch = in_str[i];
        if (std.ascii.isASCII(ch)) {
            buf[i] = std.ascii.toLower(ch);
        } else {
            buf[i] = ch;
        }
        i = i + 1;
    }
    var res = buf[0..in_str.len];
    return res;
}

///
/// performs a to uppercase conversion on a []const u8 entirely in zig
/// returns the converted array as a slice of the passed in buffer
/// returns error.ToUpperError.DestTooSmall if the buffer is too small
///
pub fn z_toupper_inplace(in_str: []u8) void {
    var i: usize = 0;
    while (i < in_str.len) {
        var ch = in_str[i];
        if (std.ascii.isASCII(ch)) {
            in_str[i] = std.ascii.toUpper(ch);
        }
        i = i + 1;
    }
}
///
/// performs a to lowercase conversion on a []const u8 entirely in zig
/// returns the converted array as a slice of the passed in buffer
/// returns error.ToUpperError.DestTooSmall if the buffer is too small
///
pub fn z_tolower_inplace(in_str: []u8, buf: []u8) ToUpperError ! []u8 {
    if (in_str.len > buf.len) {
        return error.DestTooSmall;
    }
    var i: usize = 0;
    while (i < in_str.len) {
        var ch = in_str[i];
        if (std.ascii.isASCII(ch)) {
            buf[i] = std.ascii.toLower(ch);
        } else {
            buf[i] = ch;
        }
        i = i + 1;
    }
    var res = buf[0..in_str.len];
    return res;
}
