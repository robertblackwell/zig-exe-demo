const std = @import("std");

const test_ascii = @import("zutils/test_ascii.zig");
const test_record = @import("zutils/test_record.zig");

const c = @cImport({
    @cInclude("src/zutils/c_ascii.h");
});

pub fn main() !void 
{
    // how to allocate memory - needed for the implementation fo Record
    const allocator = std.heap.c_allocator;
    var x:[]u8 = try allocator.alloc(u8, 21);
    var y = try allocator.alloc(u8, 9);
    var z = try allocator.alloc(u8, 1);
    // demonstrate that zutils with c_functions is linked to this exe
    var c_rec: [*:0]const u8  = c.c_functions_version();
    std.debug.warn("c version is : {}\n", .{c_rec});

    test_ascii.tests();
    test_record.test_record();

}