# zig-exe-demo

__zig-exe-demo__ is the first of, I hope, a number of project/steps along the path to learning Zig. 

I have chosen to publish this project because during my initial experiments with Zig I found that many of the simple illustrative zig projects I found and hoped would point me in the right direction where either out of date (using old syntac and out of date function names) or required the installation of specialist libraries, which I felt added a significant setup burden without adding any value to the zig learning experience. Maybe this project can make the early steps toward zig easier for other newbies like me.

## Installation

There is no real installation. Clone the repo and start playing.

## The project

Goals for this project.

-   demonstrate a build.zig file that builds an executable from multiple zig files and at least one .c and .h file. To this end the project comprises:

    -   a src/main.zig file.
    -   two other zig files, in a sub dir, which provide functions and a struct used in main.zig
    -   a .c and .h file which provide other functions called from main.c
    -   a build.zig file 
-   illustrates how to make c functions callable from zig
-   illustrates the use of the slice concept to create and update u8 arrays acting as "string"s
-   illustrates the use of c_allocator for dynamic memory allocation
-   illustrates getters and setters for a struct that has string ([]const u8) fields

## Updates 

It is likely that this project will evolve in a number of steps as I explore different aspects of Zig.

I will mark those steps with git tags. The first step is tagged v1.0 and corresponds to the first commit that contained a meaningful readme file.

## v2.0 Update

In this update unit tests have been added. I have not done this the usual __zig__ way as I could not figure out how to produce a binary that contained the zig tests. 

Because I could not generate a test binary I could not debug the tests in `vscode`. 

For me `vscode` debugging is important so I invented a different (not so sleek) way of doing tests.

The test driver, the program that you execute to run the tests, is in the source file `test_main.zig`, and produces a binary `build/test_main`. The `.vscode` properties file is set up to debug this binary. 

As of this tag `src/main.zig` is historical, and duplicates a lot of the test code now provided by the files

```
    src/lib/test_record.zig
    src/lib/test_ascii.zig

```

It will disappear soon.

For the next release the files `z_ascii.zig` and `c_ascii.c/h` are likely to change names as they are about more than `ascii` codes. 

The `build.zig` file has two updates for this tag.

-   the section of build code that created the executable `build/main` has been copy-pasted-editted  (I know DRY) to produce the executable `build/test_main`

-   also updated to ensure that all compiles are done in `Mode.Debug` note `b.setPreferredReleaseMode(mode)` in `build.zig`.

Finally this tag has this projects first example of __zig__ calling a `libc` function. In file `src/lib/test_ascii.zig`
```
 fn demo_c_toupper_with_error_checking(comptime bufsize: usize) void
```

calls the libc function `strlen()`.

## v3.0 Update

Poor prediction. File `z_ascii.zig` only became `ascii.zig` and `c_ascii.c/h` did not changed.

So what has happened for this update. Well, 

- the non test code inside `src/lib` became a real static library, called `libzutils.a`.

- `src/main.zig` is no longer a historical remnant but is a simple program that links against `libzutils` and calls
  a function from each of the libraries constituent files to prove the link got all the components of the library.

- the significant lesson for this update is the `addPackagePath("zutils", "src/lib.zig")` function call in the build instructions for `src/main.zig`. 

  This is required when building `src/main.zig` into an exe as without it the libraries exported symbols cannot be seen from inside `src/main.zig` It is the zig analogue of what in C would be the libraries header file.  Thus `main.zig` imports the libraries symbols with the line

  ```
  const zutils = @import("zutils");

  ```

  and  the file`src/lib.zig` determines, or "pulls in", the library symbols to be exported.

## v3.1 Update

Changed directory `lib` and file `lib.zig` to `zutils` and `zutils.zig`. Seems more in keeping with zig practice.

## v4.0 Update 

This update addresses two topics:

- re structures the directory/file structure and changes the build.zig file in preparartion for splitting this project into two git repos.
- further explores how the `addPackage` build instruction works and whether or not a build of `main.zig` needs to link against `libzutils`.

Its worth noting that all of the effort for this step in the project (and the previous one for that matter) is associated with how to manage and use the zig build system. Nothing to do with the language or zig coding.

### Linking against libzutils

What I discovered while working on this update was that if `main.zig` made no calls to functions in `c_ascii.c` then the `build.zig` file 
- did not need to have
```
        main_exe.addIncludeDir("lib/zutils");
```
- did not need to have the 
```
        main_exe.linkSystemLibraryName("zutils");
        main_exe.addLibPath("./lib/zutils/zig-cache/lib");
```
- indeed libzutils did not even have to exists.

But if `src/main.zig` did make a call to a function in `c_ascii.` than all of those statements were required.

Would I be right in concluding that when an exe (`src/main.zig`) and a library (`zutils`)consist only of `zig` files, the build of the exe, via an `addPackage` statement, pulls in the library source not the library `.a` or `.so`?

What am I missing.

The file `task.sh` demonstrates what was just described. Executed without an argument it will run 4 scenarios in which it attempts to build and run `main.zig`.
- build and run  `src/main.zig` without any c calls, without libzutils existing, no `addIncludeDir()`, no `linkSystemLibrary()`. This will run successfully. 
- build and run `src/main.zig` with C calls, with `libzutils` existing, with `addIncludeDir()` and with `linkSystemLibrary()`. This will run successfully.
- build `src/main.zig` with C calls, without the `addIncludeDir()`. The build will fail with a `cImport failed error`
- build `src/main.zig` with C calls, with the `addIncludeDir()` but without the `linkSystemLibrary()`. This build will fail with a linker error " undefined function c_functions_version".


### Preparation for a split

My next step on this process is to carve out the library `zutils` s a separate git repo. 

How to do this I copied from [git@github.com:ducdetronquito/h11.git](git@github.com:ducdetronquito/h11.git):

- make a `lib` subdirectory of the project directory at the same level as `src`. This will house a subdirectory for each dependency of the main project. In out case only one.

- make a subdirectory of `lib` called `zutils` which will hold the zutils code as a standalone project with its own `build.zig` file.

  Notice that all the test code, including `test_main.zig` went into this subdir. 

  In the next step of this project this directory will become a git submodule.

- in the `lib` directory create a file called `packages.zig`. See the file and the main `build.zig` file for details of what this file does. 

## v5.0 Update

This update splits the zutils code into a separate repo [git@github.com:robertblackwell/zig-lib-demo.git](git@github.com:robertblackwell/zig-lib-demo.git) and re-includes it in this repo as a `git subtree`. 

Here are some references on this process. Seems like an easier option than . But in any case this is such a simple case the choice is not really material.
[https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407](https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407)

[https://medium.com/@porteneuve/mastering-git-subtrees-943d29a798ec](https://medium.com/@porteneuve/mastering-git-subtrees-943d29a798ec)

This next one is probably the easiest to follow.

[https://docs.github.com/en/free-pro-team@latest/github/using-git/splitting-a-subfolder-out-into-a-new-repository](https://docs.github.com/en/free-pro-team@latest/github/using-git/splitting-a-subfolder-out-into-a-new-repository)

I am not sure where this exercise goes next. My temptation is to build a more realistic library using only zig and to make that a distinct new project.

If that happens I will update this file with a link.

## License
[MIT](https://choosealicense.com/licenses/mit/)

```

```