const std = @import("std");

pub fn add_i32(a: i32, b: i32) i32 {
    return a + b;
}

pub fn mult_8(a: i32) i32 {
    return a * 8;
}


const Vec01 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    export fn dot(self: *Vec01) f32 {
        return self.*.x;
    }
};
export fn Vec01_init(vec_ptr: *Vec01, x: f32, y: f32, z: f32) void {
    vec_ptr.*.x = x;
    vec_ptr.*.y = y;
    vec_ptr.*.z = z;
}



// export pub fn Vec_dot(self: Vec, other: Vec) f32 {
//     return self.x * other.x + self.y * other.y + self.z * other.z;
// }

