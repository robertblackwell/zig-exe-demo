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

I will mark those steps with git tags. The first step is tagged V1.0 and corresponds to the first commit that contained a meaningful readme file.

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
## License
[MIT](https://choosealicense.com/licenses/mit/)

```

```