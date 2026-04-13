#include <stdio.h>
#include <string.h>
#include "basic_algorithms.h"

/* static buffer for string-returning functions */
static char _buf[256];

int max3(int a, int b, int c) {
    int maximum = a;
    if (b > maximum) maximum = b;
    if (c > maximum) maximum = c;
    return maximum;
}

int med3(int a, int b, int c) {
    if (a >= b) {
        if (b >= c) return b;
        else if (a <= c) return a;
        else return c;
    } else if (a > c) {
        return a;
    } else if (b > c) {
        return c;
    } else {
        return b;
    }
}

const char *judge_sign(int n) {
    if (n > 0) return "positive";
    else if (n < 0) return "negative";
    else return "zero";
}

int sum_1_to_n(int n) {
    int total = 0;
    for (int i = 1; i <= n; i++) total += i;
    return total;
}

const char *alternative(int n) {
    int j = 0;
    for (int i = 0; i < n; i++) {
        _buf[j++] = (i % 2 == 0) ? '+' : '-';
    }
    _buf[j] = '\0';
    return _buf;
}

void rectangle(int area, char *buf, size_t bufsz) {
    int pos = 0;
    for (int i = 1; (long long)i * i <= area; i++) {
        if (area % i != 0) continue;
        pos += snprintf(buf + pos, bufsz - (size_t)pos, "%dx%d ", i, area / i);
    }
}

void multiplication_table(char *buf, size_t bufsz) {
    int pos = 0;
    pos += snprintf(buf + pos, bufsz - (size_t)pos, "%s\n", "--------------------------");
    for (int i = 1; i <= 9; i++) {
        for (int j = 1; j <= 9; j++) {
            pos += snprintf(buf + pos, bufsz - (size_t)pos, "%3d", i * j);
        }
        pos += snprintf(buf + pos, bufsz - (size_t)pos, "\n");
    }
    snprintf(buf + pos, bufsz - (size_t)pos, "%s", "--------------------------");
}

void triangle_lb(int n, char *buf, size_t bufsz) {
    int pos = 0;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j <= i; j++) {
            buf[pos++] = '*';
        }
        buf[pos++] = '\n';
    }
    buf[pos] = '\0';
    (void)bufsz;
}
