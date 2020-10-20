const std = @import("std");
const z_ascii = @import("z_ascii.zig");

const address_length = 100;

fn mkname(aname: []const u8) []u8 {
    var tmp: []u8 = std.heap.c_allocator.alloc(u8, aname.len) catch unreachable;
    std.mem.copy(u8, tmp, aname);
    return tmp;
}

pub const Record = struct {
    name: []const u8,
    address: [100]u8,

    pub fn init(aname: []const u8, an_addr:[]const u8) Record {
        var tmp: []u8 = std.heap.c_allocator.alloc(u8, aname.len) catch unreachable;
        std.mem.copy(u8, tmp, aname);

        var r = Record{
            .name = tmp,
            .address = [_]u8{0} ** address_length,
        };
        std.mem.copy(u8, &(r.address), an_addr);
        return r;
    }
    pub fn set_name(self: *Record, aname: []const u8) void {
        // std.heap.c_allocator.free(self.name);
        var tmp = std.heap.c_allocator.alloc(u8, aname.len) catch unreachable;
        var tmp_slice = tmp[0..aname.len];
        std.debug.warn("{}\n", .{@typeName(@TypeOf(tmp))});
        std.debug.warn("{}\n", .{@typeName(@TypeOf(tmp_slice))});
        std.mem.copy(u8, tmp, aname);
        // // self.name = mkname(aname);
        self.name = tmp[0..aname.len];
    } 
    pub fn get_name(self: *Record) []const u8 {
        return self.name;
    }
    pub fn set_address(self: *Record, addr: []const u8) void {
        std.mem.copy(u8, self.address, addr);
    }
    pub fn get_address(self: *Record) []const u8 {
        return self.address;
    }
    pub fn toupper_name(self: Record) void {
        const bufsize = 100;
        const buf_len = bufsize;
        var out_str = [_]u8{0} ** bufsize;
        var slice = out_str[0..bufsize];
        // var aslice: []u8 = self.name[0..100];
        // z_ascii.z_toupper_inplace(aslice);
        std.debug.warn("Here\n", .{});
    }
};

