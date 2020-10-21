const std = @import("std");

const test_ascii = @import("lib/test_ascii.zig");
const test_record = @import("lib/test_record.zig");

const c = @cImport({
    @cInclude("src/lib/c_ascii.h");
});


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

    test_ascii.tests();
    test_record.test_record();

}