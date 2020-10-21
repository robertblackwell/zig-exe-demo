const Builder = @import("std").build.Builder;
const builtin = @import("builtin");

///
/// This script builds a single executable named proj01
/// the main() function for the exec lives in src/main.zig
/// and the imports in the main.zig file pull in all the other zig
/// files required to build the exe.
///
/// However C files are not pulled in automatically, this is achiieved by
/// the exe.addCSourceFile() line.
///
/// The C file(s) will not compile unless the headers they include can be found,
/// since src/lib is a non standard header search path it must be added.
/// thats the purpose of :
///     exe.addIncludeDir() 
///     exe.addSystemIncludeDir()
///
/// WARNING - the calls that add include directories have changed over time.
/// this is the correct usage as of Oct 2020 and zig version 0.6.0+288198e51
///
pub fn build(b: *Builder) void {
    const mode = builtin.Mode.Debug;
    b.setPreferredReleaseMode(mode);

    const exe = b.addExecutable("proj01", "src/main.zig");
    exe.addSystemIncludeDir(".");
    exe.addIncludeDir(".");
    exe.addSystemIncludeDir("./lib");
    exe.addIncludeDir("./lib");
    exe.addCSourceFile("src/lib/c_ascii.c", &[_][]const u8{"-std=c99", "-g"});
    exe.linkSystemLibrary("c");
    // these last 4 lines I dont really understand, but without them the build seemed to run but
    // no executable could be found after the build
    exe.setOutputDir("build");
    exe.install();
    const run = exe.run();
    run.step.dependOn(b.getInstallStep());

    const test_exe = b.addExecutable("proj01_test", "src/test_main.zig");
    test_exe.addSystemIncludeDir(".");
    test_exe.addIncludeDir(".");
    test_exe.addSystemIncludeDir("./lib");
    test_exe.addIncludeDir("./lib");
    test_exe.addCSourceFile("src/lib/c_ascii.c", &[_][]const u8{"-std=c99", "-g"});
    test_exe.linkSystemLibrary("c");
    // these last 4 lines I dont really understand, but without them the build seemed to run but
    // no executable could be found after the build
    test_exe.setOutputDir("build");
    test_exe.install();

    // the rest I am experimenting with

    // const lib = b.addStaticLibrary("zigtmp", "src/vector.zig");

    // lib.setBuildMode(mode);
    // switch (mode) {
    //     .Debug, .ReleaseSafe => lib.bundle_compiler_rt = true,
    //     .ReleaseFast, .ReleaseSmall => lib.disable_stack_probing = true,
    // }
    // lib.force_pic = true;
    // lib.setOutputDir("build");
    // lib.install();

    var zig_test = b.addTest("src/test.zig");
    zig_test.setBuildMode(mode);
    zig_test.setOutputDir("build");
    // zig_test.install();

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&zig_test.step);


}
