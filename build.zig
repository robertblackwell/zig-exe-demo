const Builder = @import("std").build.Builder;
const builtin = @import("builtin");
const packages = @import("lib/packages.zig");

const options = @import("src/main_options.zig");

// const main_calls_c_functions = @import("src/main_options.zig").main_calls_c_functions;
// const build_zutils = @import("src/main_options.zig").build_zutils;
// const link_against_zutils = @import("src/main_options.zig").link_against_zutils;
// const add_zutils_include_dir = @import("src/main_options.zig").add_zutils_include_dir;

const use_package_zig = @import("src/main_options.zig").use_package_zig;


pub fn build(b: *Builder) void {
    const mode = builtin.Mode.Debug;
    b.setPreferredReleaseMode(mode);

    // build an exe from src/main.zig and link against lib
    const main_exe = b.addExecutable("main", "src/main.zig");
    // point the build at the zutils package
    if (options.use_package_zig) {
        main_exe.addPackage(packages.zutils);
    } else {
        main_exe.addPackagePath("zutils", "lib/zutils/src/zutils.zig");
    }
    // if main.zig calls any of the c functions in package zutils have to add the next 3 line 
    // there must be a way to avoid this but without some docs for the build system impossible to
    // guess how. 
    // Its worth noting - as a clue - that without the next 3 lines we get a link error not a compile error
    // so the addPackage() statement exposes the c header files but does not  
    if (options.add_zutils_include_dir) {
        main_exe.addIncludeDir("lib/zutils");
    }
    if (options.link_against_zutils) {
        main_exe.linkSystemLibraryName("zutils");
        main_exe.addLibPath("./lib/zutils/zig-cache/lib");
    }
    // since main.zig (or zutils package) might call libc functions link in libc
    main_exe.linkSystemLibrary("c");

    main_exe.setOutputDir("build");
    main_exe.setBuildMode(mode);
    main_exe.install();

}
