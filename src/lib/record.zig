const std = @import("std");

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
    pub fn toupper_name(self.Record) void {

    }
};

