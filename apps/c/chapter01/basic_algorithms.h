#ifndef BASIC_ALGORITHMS_H
#define BASIC_ALGORITHMS_H

#include <stddef.h>

int  max3(int a, int b, int c);
int  med3(int a, int b, int c);
const char *judge_sign(int n);
int  sum_1_to_n(int n);
const char *alternative(int n);
void rectangle(int area, char *buf, size_t bufsz);
void multiplication_table(char *buf, size_t bufsz);
void triangle_lb(int n, char *buf, size_t bufsz);

#endif /* BASIC_ALGORITHMS_H */
