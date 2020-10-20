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

## License
[MIT](https://choosealicense.com/licenses/mit/)