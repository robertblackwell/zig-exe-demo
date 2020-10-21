#include <stdio.h>
#include <ctype.h>
#include <assert.h>
#include <string.h>

#include "c_ascii.h"

const char* c_functions_version() {
    return "version 0.9.1";
}
int c_strlen(const char* in_str) {
    return strlen(in_str);
}
int c_is_ascii_ch(const char ch) {
    return isalpha((int) ch);
}
int c_toupper_ch(const char ch) {
    return toupper((int)ch);
}
int c_tolower_ch(const char ch) {
    return tolower((int)ch);
}
// return length of uppercased string or -1 is buffer is too small
int c_toupper(const char* in_str, char* out_str, unsigned max_out_len) {

    int j = 0;
    while(in_str[j]) {
        char ch = in_str[j];
        if(c_is_ascii_ch(ch)) {
            (out_str)[j] = c_toupper_ch(ch);
        } else {
            out_str[j] = ch;
        }  
        j++;
        if(j >= max_out_len)
            return -1;
    }
    out_str[j] = '\0';
    return j;
}
int c_tolower(const char* in_str, char* out_str, unsigned max_out_len) {

    int j = 0;
    while(in_str[j]) {
        char ch = in_str[j];
        if (c_is_ascii_ch(ch)) {
            (out_str)[j] = c_tolower_ch(ch);
        } else {
            out_str[j] = ch;
        } 
        j++;
        if(j >= max_out_len)
            return -1;
    }
    out_str[j] = '\0';
    return j;
}
