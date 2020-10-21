const std = @import("std");
const utils = @import("zutils");

pub fn main() !void 
{
    // how to allocate memory - needed for the implementation fo Record
    const allocator = std.heap.c_allocator;
    var x:[]u8 = try allocator.alloc(u8, 21);
    var y = try allocator.alloc(u8, 9);
    var z = try allocator.alloc(u8, 1);

    // demonstrate that zutils is linked to this exe
    var v = utils.ascii.z_version();
    std.debug.warn("z_version is : {}\n", .{v});

    // demonstrate that zutils is linked to this exe
    var v_rec = utils.record.version();
    std.debug.warn("record version is : {}\n", .{v_rec});

    // demonstrate that zutils with c_functions is linked to this exe
    var c_rec: [*:0]const u8 = utils.c.c_functions_version();
    std.debug.warn("c version is : {}\n", .{c_rec});

}