const std = @import("std");

pub const zutils = std.build.Pkg {
    .name = "zutils",
    .path = "lib/zutils/src/zutils.zig",
    .dependencies = null,
};