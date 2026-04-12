#include <string.h>
#include <stdio.h>
#include "arrays.h"

int max_of(const int *a, int n) {
    int maximum = a[0];
    for (int i = 1; i < n; i++) {
        if (a[i] > maximum) maximum = a[i];
    }
    return maximum;
}

void reverse_array(int *a, int n) {
    for (int i = 0; i < n / 2; i++) {
        int tmp = a[i];
        a[i] = a[n - i - 1];
        a[n - i - 1] = tmp;
    }
}

void card_conv(int x, int r, char *buf, size_t bufsz) {
    const char *dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    char tmp[64];
    int len = 0;
    while (x > 0) {
        tmp[len++] = dchar[x % r];
        x /= r;
    }
    /* reverse */
    int j = 0;
    for (int i = len - 1; i >= 0 && (size_t)j < bufsz - 1; i--) {
        buf[j++] = tmp[i];
    }
    buf[j] = '\0';
}

int prime1(int x) {
    int counter = 0;
    for (int n = 2; n <= x; n++) {
        for (int i = 2; i < n; i++) {
            counter++;
            if (n % i == 0) break;
        }
    }
    return counter;
}

int prime2(int x) {
    int counter = 0;
    int ptr = 0;
    int prime[500];

    prime[ptr++] = 2;

    for (int n = 3; n <= x; n += 2) {
        int found = 0;
        for (int i = 1; i < ptr; i++) {
            counter++;
            if (n % prime[i] == 0) { found = 1; break; }
        }
        if (!found) prime[ptr++] = n;
    }
    return counter;
}

int prime3(int x) {
    (void)x; /* fixed range 1-1000 as per Python reference */
    int counter = 0;
    int ptr = 0;
    int prime[500];

    prime[ptr++] = 2;
    prime[ptr++] = 3;

    for (int n = 5; n <= 1000; n += 2) {
        int i = 1;
        int found = 0;
        while (prime[i] * prime[i] <= n) {
            counter += 2;
            if (n % prime[i] == 0) { found = 1; break; }
            i++;
        }
        if (!found) { prime[ptr++] = n; counter++; }
    }
    return counter;
}
