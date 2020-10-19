const std = @import("std");
const z_ascii = @import("z_ascii.zig");

pub const Record = struct {
    name: []const u8,
    pub fn init(name: []const u8) Record {
        return Record {
            .name = name,
        };
    }
    pub fn set_name(self: Record, name: []const u8) viod {
        self.name = name;
    } 
    pub fn get_name() []u8 {
        return self.name;
    }
    pub fn toupper_name(self: Record) void {
        const bufsize = 100;
        const buf_len = bufsize;
        var out_str = [_]u8{0} ** bufsize;
        var slice = out_str[0..bufsize];

        // var res = z_ascii.z_toupper_inplace(self.name);
        std.debug.warn("Here\n", .{});
    }
};

