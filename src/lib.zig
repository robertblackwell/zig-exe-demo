pub const record = @import("lib/record.zig");
pub const ascii = @import("lib/ascii.zig");
pub const c = @cImport({
    @cInclude("src/lib/c_ascii.h");
});
