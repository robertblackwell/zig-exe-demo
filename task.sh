C_CALLS=$1
LINK_ZUTILS=$2
BUILD_ZUTILS=$3
# 
#  build main.zig to call a c function from libzutils
# 
# remove all libzutil build products
function clean_zlib() {
    rm -rf lib/zutils/zig-cache/*
    rm -rf lib/zutils/build/*
}
# remove all main.zig build products
function clean_main() {
    rm -rf zig-cache/*
    rm -rf build/*
    # remove main options file
    rm src/main_options.zig
}

function build_zutils() {
    (cd lib/zutils; zig build)
}

function make_options() {

    echo "pub const main_calls_c_functions  = ${1};" 
    echo "pub const build_zutils = ${2};" 
    echo "pub const link_against_zutils = ${3};" 
    echo "pub const add_zutils_include_dir = ${4};" 
    echo "pub const use_package_zig = false;"
}

function build_run_main() {
    echo " "
    echo "Listing of src/main_options.zig "
    echo " "
    cat src/main_options.zig
    echo " "
    zig build
    ./zig-cache/bin/main
}

function run() {
    clean_zlib
    clean_main
    make_options $C_CALLS $BUILD_ZUTILS $LINK_ZUTILS
    if [ ${BUILD_ZUTILS} == "true"  ]; then
        build_zutils
    fi
    build_run_main
}

function no_libzutils_no_c_calls() {
    echo "=============================================================================="
    echo "do not build libzutils," 
    echo "do not link against libzutils," 
    echo "do not compile against zutils" 
    echo "and do not make any c calls"
    echo " "
    read -p "Are you ready - type y or n no return (y/n)? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        clean_zlib
        clean_main
        make_options false false false false > src/main_options.zig
        build_run_main
    fi
    echo "=============================================================================="
}    
function build_libzutils_link_zutils_compile_zutils_c_calls() {
    echo "=============================================================================="
    echo "do build libzutils," 
    echo "do link against libzutils," 
    echo "do compile against zutils" 
    echo "and do not make any c calls"
    echo " "
    read -p "Are you ready - type y or n no return (y/n)? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        clean_zlib
        clean_main
        make_options true true true true > src/main_options.zig
        build_zutils
        build_run_main
    fi
}
function do_not_compile_against_zutils_do_c_calls() {
    echo "=============================================================================="
    echo "do build libzutils," 
    echo "do not link against libzutils," 
    echo "do not compile against zutils" 
    echo "and do not make any c calls"
    echo " "
    echo "The build of main will fail with :"

    echo "  cImport failed"

    echo " "
    read -p "Are you ready - type y or n no return (y/n)? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        clean_zlib
        clean_main
        make_options true true false false > src/main_options.zig
        build_run_main
    fi
}
function compile_against_zutils_dont_link_libzutils_make_c_calls() {
    echo "=============================================================================="
    echo "do build libzutils," 
    echo "do not link against libzutils," 
    echo "do compile against zutils" 
    echo "and do not make any c calls"
    echo " "
    echo "The build of main will fail with :"

    echo "   lld error Undefined function c_functions_version"

    echo " "
    read -p "Are you ready - type y or n no return (y/n)? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        clean_zlib
        clean_main
        make_options true true false true > src/main_options.zig
        build_zutils
        build_run_main
    fi
}

function reset() {
    clean_zlib
    clean_main
    make_options true true true true > src/main_options.zig
    build_zutils
    build_run_main
}

function build() {
    reset
}

function experiment() {
    no_libzutils_no_c_calls
    build_libzutils_link_zutils_compile_zutils_c_calls
    do_not_compile_against_zutils_do_c_calls
    compile_against_zutils_dont_link_libzutils_make_c_calls
}

if [ "$1" == "" ]; then 
    experiment
else
"$@"
fi

# make_options true ture false 
# if [ $1 == "reset" ]; then 
#     reset
# else
#     no_libzutils_no_c_calls
#     build_libzutils_link_zutils_compile_zutils_c_calls
#     do_not_compile_against_zutils_do_c_calls
#     compile_against_zutils_dont_link_libzutils_make_c_calls
#     # return to default settings
# fi