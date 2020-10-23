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

    // build a lib out of src/lib.zig which pulls in 
    // src/lib/record.zig and src/lib/ascii.zig.
    //
    // addCSourceFile() pulls in src/lib/c_ascii.c 
    //
    // Unimaginatively it is called "lib: - will change that on the next
    // evolution.
    //
    const lib = b.addStaticLibrary("zutils", "src/zutils.zig");
    lib.addIncludeDir(".");
    lib.addCSourceFile("src/c_ascii.c", &[_][]const u8{"-std=c99", "-g"});
    lib.linkSystemLibrary("c");
    lib.setBuildMode(mode);
    lib.install();

    // build the test executable test_main - this does not link against lib
    // but directly pulls in the source src/lib including all the test files
    const test_exe = b.addExecutable("test_main", "src/test_main.zig");
    test_exe.addSystemIncludeDir(".");
    test_exe.addIncludeDir(".");
    test_exe.addSystemIncludeDir("./src");
    test_exe.addIncludeDir("./src");
    test_exe.addCSourceFile("src/c_ascii.c", &[_][]const u8{"-std=c99", "-g"});
    test_exe.linkSystemLibrary("c");
    test_exe.setOutputDir("build");
    test_exe.install();
    

}
