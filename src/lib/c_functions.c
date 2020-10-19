#include <stdio.h>
#include <ctype.h>
#include <assert.h>

#include "c_functions.h"

void c_test_func(const char* s) {
    const char* x = s;
    printf("Inside ctest to prove its the lib version %s\n", s);
}
// return length of uppercased string
unsigned c_toupper(const char* in_str, char* out_str, unsigned max_out_len) {

    int j = 0;
    while(in_str[j]) {
        char ch = in_str[j];
        (out_str)[j] = toupper(ch); 
        j++;
        assert(j < max_out_len);
    }
    out_str[j] = '\0';
    return j;
}
