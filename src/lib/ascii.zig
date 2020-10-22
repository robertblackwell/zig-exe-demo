///
/// This is a simple zig library for converting the ascii members of a []u8 to
/// upper or lower case
///
const std = @import("std");
const assert = @import("std").debug.assert;
const c = @cImport({
    // note this is relative to project dir
    @cInclude("src/lib/c_ascii.h");
    @cInclude("string.h");
});

pub fn z_version() []const u8 {
    return "v1.0.0";
}

/// The type of error returned by z_toupper if the buffer 
/// is too small
pub const ToUpperError = error {
    DestTooSmall,
};
///
/// force a call into c_ascii and libc
///
pub fn z_strlen(s: [*:0]const u8) usize {
    var len = c.strlen(s);
    return c.c_strlen(s);
}
/// copy a slice into a buffer and resturn a slice of that buffer representing the copied data
///
/// @param dst a slice of a destination buffer - it sets the max value on the size of the copy
/// @param src a const slice the source from which the copy will come
/// @return a sub slice of dst representing the data that was copied
///
pub fn z_cpy(dst: []u8, src: []const u8) []u8 {
    var l1 = dst.len;
    for(src) |ch, i| {
        dst[i] = src[i];
    }
    return dst[0..src.len];
}
///
/// test two slices for equality
///
pub fn z_streq(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) {
        return false;
    }
    for(a) |ch, i| {
        if (a[i] != b[i]) {
            return false;
        }
    }
    return true;
}

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
