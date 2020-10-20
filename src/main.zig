const std = @import("std");
const assert = @import("std").debug.assert;

///
/// the lib.zig file is a consolidator of symbols exported from the lib directory.
/// look inside the lib.zig file to see how symbols are pulled up from the lib directory
/// so that clients of the lib  dont need to know where symbols live in the lib dir
///
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
/// copy a slice into a buffer and resturn a slice of that buffer representing the copied data
///
/// @param dst a slice of a destination buffer - it sets the max value on the size of the copy
/// @param src a const slice the source from which the copy will come
/// @return a sub slice of dst representing the data that was copied
///
fn z_cpy(dst: []u8, src: []const u8) []u8 {
    var l1 = dst.len;
    for(src) |ch, i| {
        dst[i] = src[i];
    }
    return dst[0..src.len];
}
fn z_streq(a: []const u8, b: []const u8) bool {
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
fn demo_string_copy() void {
    var s = "thisisastring";
    var buf:[100]u8 = [_]u8{0} ** 100;
    for (s) |ch, i| {
        buf[i] = s[i];
    }
    var slice1 = buf[0..s.len];

    for(s) |ch, i| {
        assert(s[i] == buf[i]);
    }
    var buf2:[100]u8 = [_]u8{0} ** 100;
    var slice2 = buf2[0..100];
    var res_slice = z_cpy(slice2, slice1);
    std.debug.warn("Hello \n", .{});
}
fn record_set_name(record: *Record, aname: []const u8) void {
    var allocd_slice = std.heap.c_allocator.alloc(u8, 100) catch unreachable;
    std.mem.copy(u8, allocd_slice, aname);
    var new_slice = allocd_slice[0..aname.len];
    var slx  = allocd_slice;
    slx = new_slice;
    record.name = slx;
    std.debug.warn("Done\n", .{});
}
pub fn main() !void 
{
    // how to allocate memory - needed for the implementation fo Record
    const allocator = std.heap.c_allocator;
    var x:[]u8 = try allocator.alloc(u8, 21);
    var y = try allocator.alloc(u8, 9);
    var z = try allocator.alloc(u8, 1);

    // note putting the c_functions_version() call in the print statement like so
    // std.debug.warn("main - using c_functions version {}\n", .{c_functions_version()}")
    // prints the pointer value not the string value
    var vers: [*:0]const u8 = c.c_functions_version();
    std.debug.warn("Main - using c_functions version {}\n", .{vers});

    // the next block of calls demo manipulating strings 
    // and in the case of the demo_zig_xxx also demo zig error handling
    // inspect the demo_ functions for more understanding
    // these functions also demonstrate compile time arguments
    demo_zig_toupper_with_error_checking(100);
    demo_zig_toupper_with_error_checking(10);
    demo_c_toupper_with_error_checking(100);
    demo_c_toupper_with_error_checking(10);
    demo_string_copy();

    // these calls demo struct getter and setter for string fields
    // two different strategies are implemented.
    // In each case the record takes ownership of the memory that holds
    // the name and address strings.
    // the name field is dynamically allocated
    // the address field is kept in a buffer private to each instance of Record
    var tst = Record.init("hello this is the world", "Andthisisanaddress");
    std.debug.assert(z_streq("hello this is the world", tst.get_name()));
    std.debug.assert(z_streq("Andthisisanaddress", tst.get_address()));
    tst.set_name("AnewName");
    tst.set_address("ANEWADDRT");
    std.debug.assert(z_streq("AnewName", tst.get_name()));
    std.debug.assert(z_streq("ANEWADDRT", tst.get_address()));
    std.debug.warn("tst.name is : {}\n", .{tst.name});

}