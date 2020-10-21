const std = @import("std");
const assert = @import("std").debug.assert;

const z_ascii = @import("z_ascii.zig");
const Record = @import("record.zig").Record;

pub fn test_record() void {
    // these calls demo struct getter and setter for string fields
    // two different strategies are implemented.
    // In each case the record takes ownership of the memory that holds
    // the name and address strings.
    // the name field is dynamically allocated
    // the address field is kept in a buffer private to each instance of Record
    var tst = Record.init("hello this is the world", "Andthisisanaddress");
    std.debug.assert(z_ascii.z_streq("hello this is the world", tst.get_name()));
    std.debug.assert(z_ascii.z_streq("Andthisisanaddress", tst.get_address()));
    tst.set_name("AnewName");
    tst.set_address("ANEWADDRT");
    std.debug.assert(z_ascii.z_streq("AnewName", tst.get_name()));
    std.debug.assert(z_ascii.z_streq("ANEWADDRT", tst.get_address()));
    std.debug.warn("tst.name is : {}\n", .{tst.name});
}

