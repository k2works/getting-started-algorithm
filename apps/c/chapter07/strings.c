#include <string.h>
#include <stdlib.h>
#include "strings.h"

int bf_match(const char *text, const char *pattern) {
    int n = (int)strlen(text), m = (int)strlen(pattern);
    if (m == 0) return 0;
    for (int i = 0; i <= n - m; i++) {
        int j = 0;
        while (j < m && text[i+j] == pattern[j]) j++;
        if (j == m) return i;
    }
    return -1;
}

int kmp_match(const char *text, const char *pattern) {
    int n = (int)strlen(text), m = (int)strlen(pattern);
    if (m == 0) return 0;
    int *table = (int *)calloc((size_t)m, sizeof(int));
    int k = 0;
    for (int i = 1; i < m; i++) {
        while (k > 0 && pattern[k] != pattern[i]) k = table[k-1];
        if (pattern[k] == pattern[i]) k++;
        table[i] = k;
    }
    k = 0;
    int result = -1;
    for (int i = 0; i < n; i++) {
        while (k > 0 && text[i] != pattern[k]) k = table[k-1];
        if (text[i] == pattern[k]) k++;
        if (k == m) { result = i - m + 1; break; }
    }
    free(table);
    return result;
}

int bm_match(const char *text, const char *pattern) {
    int n = (int)strlen(text), m = (int)strlen(pattern);
    if (m == 0) return 0;
    int bad[256];
    for (int i = 0; i < 256; i++) bad[i] = -1;
    for (int i = 0; i < m; i++) bad[(unsigned char)pattern[i]] = i;
    int s = 0;
    while (s <= n - m) {
        int j = m - 1;
        while (j >= 0 && pattern[j] == text[s+j]) j--;
        if (j < 0) return s;
        int skip = j - bad[(unsigned char)text[s+j]];
        s += (skip < 1) ? 1 : skip;
    }
    return -1;
}

int count_chars(const char *s, CharCount *cc, int max_chars) {
    int n = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        char c = s[i];
        int found = 0;
        for (int j = 0; j < n; j++) {
            if (cc[j].c == c) { cc[j].count++; found = 1; break; }
        }
        if (!found && n < max_chars) { cc[n].c = c; cc[n].count = 1; n++; }
    }
    return n;
}

void reverse_string(const char *s, char *buf, size_t bufsz) {
    int len = (int)strlen(s);
    int j = 0;
    for (int i = len - 1; i >= 0 && (size_t)j < bufsz - 1; i--)
        buf[j++] = s[i];
    buf[j] = '\0';
}

int is_palindrome(const char *s) {
    int len = (int)strlen(s);
    for (int i = 0; i < len / 2; i++)
        if (s[i] != s[len - i - 1]) return 0;
    return 1;
}
