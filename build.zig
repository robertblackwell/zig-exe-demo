const Builder = @import("std").build.Builder;
const builtin = @import("builtin");


pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("proj01", "src/main.zig");
    exe.addSystemIncludeDir(".");
    exe.addIncludeDir(".");
    exe.addCSourceFile("src/c_test_func.c", &[_][]const u8{"-std=c99"});
    exe.linkSystemLibrary("c");
    exe.setOutputDir("build");
    exe.install();
    const run = exe.run();
    run.step.dependOn(b.getInstallStep());


    // const lib = b.addStaticLibrary("zigtmp", "src/vector.zig");

    // lib.setBuildMode(mode);
    // switch (mode) {
    //     .Debug, .ReleaseSafe => lib.bundle_compiler_rt = true,
    //     .ReleaseFast, .ReleaseSmall => lib.disable_stack_probing = true,
    // }
    // lib.force_pic = true;
    // lib.setOutputDir("build");
    // lib.install();

    // var zig_test = b.addTest("tests/test_1.zig");
    // zig_test.setOutputDir("build");
    // zig_test.setBuildMode(mode);

    // const test_step = b.step("test", "Run library tests");
    // test_step.dependOn(&zig_test.step);
}
