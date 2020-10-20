const std = @import("std");
const z_ascii = @import("z_ascii.zig");

// a const specifying the size of the address buffer
const address_length = 100;

fn mkname(aname: []const u8) []u8 {
    var tmp: []u8 = std.heap.c_allocator.alloc(u8, aname.len) catch unreachable;
    std.mem.copy(u8, tmp, aname);
    return tmp;
}

pub const Record = struct {
    // name is stored as a slice - memory is dynamically allocated for it
    name: []const u8,
    // address is stored as a buffer internal to each Record instance 
    // and a length field
    // from these two a slice can always be constructed when  an address value is required
    address_buf: [100]u8,
    address_len: usize,

    ///
    /// Initialize a new Record instance with a name and address
    ///
    pub fn init(aname: []const u8, an_addr:[]const u8) Record {
        var tmp: []u8 = std.heap.c_allocator.alloc(u8, aname.len) catch unreachable;
        std.mem.copy(u8, tmp, aname);

        var r = Record{
            .name = tmp,
            .address_buf = [_]u8{0} ** address_length,
            .address_len = 0,
        };
        std.mem.copy(u8, &(r.address_buf), an_addr);
        r.address_len = an_addr.len;
        return r;
    }
    ///
    /// Set a Record instance name field to a new value
    ///
    pub fn set_name(self: *Record, aname: []const u8) void {
        // dealloc the memory holding the previous value 
        std.heap.c_allocator.free(self.name);
        // allocate enough memory for the new value - ignore errors
        var tmp = std.heap.c_allocator.alloc(u8, aname.len) catch unreachable;
        // make a slice from the alloced memory the same size as aname arg
        var tmp_slice = tmp[0..aname.len];
        // copy the new value into the alloc'd memory
        std.mem.copy(u8, tmp, aname);
        // set the name field to the appropriate slice
        self.name = tmp[0..aname.len];
    } 
    ///
    /// get a slice holding the name field value
    ///
    pub fn get_name(self: *Record) []const u8 {
        return self.name;
    }
    ///
    /// set the address field to a new value
    ///
    pub fn set_address(self: *Record, addr: []const u8) void {
        // make sure the new value will fit in the buffer
        // need to come back and fit the error handling
        std.debug.assert(address_length >= addr.len);
        // copy the new value into the buffer
        std.mem.copy(u8, &(self.address_buf), addr);
        // update the length field
        self.address_len = addr.len;
    }
    ///
    /// get the address value as a slice
    ///
    pub fn get_address(self: *Record) []const u8 {
        return self.address_buf[0..self.address_len];
    }
    ///
    /// convert the name value to uppercase
    ///
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

