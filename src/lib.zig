pub const record = @import("record.zig");
pub const ascii = @import("ascii.zig");
pub const c = @cImport({
    @cInclude("src/c_ascii.h");
});
