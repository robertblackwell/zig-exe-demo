const Builder = @import("std").build.Builder;
const builtin = @import("builtin");

// pub fn build(b: *Builder) void {
//     const mode = b.standardReleaseOptions();
//     const lib = b.addStaticLibrary("http", "src/main.zig");
//     lib.setBuildMode(mode);
//     lib.install();

//     var main_tests = b.addTest("src/test.zig");
//     main_tests.setBuildMode(mode);

//     const test_step = b.step("test", "Run library tests");
//     test_step.dependOn(&main_tests.step);
// }

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

    // build the lib
    const lib = b.addStaticLibrary("zutils", "src/main.zig");
    lib.addSystemIncludeDir(".");
    lib.addIncludeDir(".");
    lib.addSystemIncludeDir("./src");
    lib.addIncludeDir("./src");
    lib.addCSourceFile("src/lib/c_ascii.c", &[_][]const u8{"-std=c99", "-g"});
    lib.linkSystemLibrary("c");
    lib.setBuildMode(mode);
    lib.install();

    // zig test build - leaving out for the moment
    const ztest = false;
    if(ztest) {
        var main_tests = b.addTest("src/test.zig");
        main_tests.setBuildMode(mode);
        
        const test_step = b.step("test", "Run library tests");
        test_step.dependOn(&main_tests.step);
    }
    if(true) {
        // build the test executable
        const main_exe = b.addExecutable("main", "src/main.zig");
        main_exe.addPackagePath("zutils", "src/lib.zig");
        main_exe.addIncludeDir(".");
        main_exe.linkSystemLibrary("c");
        main_exe.linkLibrary(lib);
        main_exe.addLibPath("./zig_cache/lib");
        // these last 4 lines I dont really understand, but without them the build seemed to run but
        // no executable could be found after the build
        main_exe.setOutputDir("build");
        main_exe.install();
    }
    if (true) {
    // build the test executable
    const test_exe = b.addExecutable("test_main", "src/test_main.zig");
    test_exe.addSystemIncludeDir(".");
    test_exe.addIncludeDir(".");
    test_exe.addSystemIncludeDir("./src");
    test_exe.addIncludeDir("./src");
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
}
