const std = @import("std");
const z_ascii = @import("z_ascii.zig");

pub const Record = struct {
    name: [100]u8,
    pub fn init(aname: []const u8) Record {
        var r = Record {
        };
        var i = 0;
        while (i < aname.len) {
            r.name[i] = aname[i];
            i = i + 1;
        }
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

