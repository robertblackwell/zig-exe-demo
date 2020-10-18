const std = @import("std");

pub const Test = struct {
    name: []const u8,
    pub fn init(name: []const u8) Test {
        return Test {
            .name = name,
        };
    }
};

