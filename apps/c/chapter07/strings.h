#ifndef STRINGS_H
#define STRINGS_H

#include <stddef.h>

int bf_match(const char *text, const char *pattern);
int kmp_match(const char *text, const char *pattern);
int bm_match(const char *text, const char *pattern);

typedef struct { char c; int count; } CharCount;
int  count_chars(const char *s, CharCount *cc, int max_chars);
void reverse_string(const char *s, char *buf, size_t bufsz);
int  is_palindrome(const char *s);

#endif /* STRINGS_H */
