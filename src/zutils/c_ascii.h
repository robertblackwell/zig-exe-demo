#ifndef c_functions_h
#define c_functions_h
#include <stdio.h>

int c_strlen(const char* in_str);

///
/// this is a simple C demo library for converting the ascii members of a string to upper or lower case 
///

///
/// returns a pointer to a static string with the version number for this library
///
const char* c_functions_version();


///
/// converts str to upper case (only the a-z) and places the result in out_str
/// if max_out_len is too small to hold all of the converted str
/// return -1 else return the length of the converted string
/// in the event of an error a partially converted string may have been placed into
/// out_str
///
int c_toupper(const char* str, char* out_str, unsigned max_out_len);

///
/// converts str to lower case (only the A-Z) and places the result in out_str
/// if max_out_len is too small to hold all of the converted str
/// return -1 else return the length of the converted string
/// in the event of an error a partially converted string may have been placed into
/// out_str
///
int c_tolower(const char* str, char* out_str, unsigned max_out_len);

#endif