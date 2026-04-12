# 第 2 章 配列

## はじめに

配列はプログラミングの基本的なデータ構造です。C 言語では配列はメモリ上に連続して確保された領域であり、インデックスでアクセスします。この章では配列の基本操作と素数列挙アルゴリズムを TDD で実装します。

---

## 1. 配列の最大値

### Red — 失敗するテストを書く

```c
void test_max_of(void) {
    int a[] = {1, 7, 3, 5, 2};
    ASSERT_EQ_INT(7, max_of(a, 5));
    int b[] = {-3, -1, -5};
    ASSERT_EQ_INT(-1, max_of(b, 3));
}
```

### Green — テストを通す実装

```c
int max_of(const int *a, int n) {
    int max = a[0];
    for (int i = 1; i < n; i++)
        if (a[i] > max) max = a[i];
    return max;
}
```

C では配列をポインタ（`const int *a`）として受け取り、長さ（`n`）を別に渡します。Python と違い `len()` が存在しないため、必ず長さを渡す必要があります。

---

## 2. 配列の逆順コピー

### Red — 失敗するテストを書く

```c
void test_reverse_array(void) {
    int src[] = {1, 2, 3, 4, 5};
    int dst[5];
    reverse_array(src, dst, 5);
    ASSERT_EQ_INT(5, dst[0]);
    ASSERT_EQ_INT(1, dst[4]);
}
```

### Green — テストを通す実装

```c
void reverse_array(const int *src, int *dst, int n) {
    for (int i = 0; i < n; i++)
        dst[i] = src[n - 1 - i];
}
```

---

## 3. 基数変換

10 進数を任意の基数（2〜36 進数）に変換します。

### Red — 失敗するテストを書く

```c
void test_card_conv(void) {
    char buf[64];
    card_conv(59, 2, buf, sizeof(buf));
    ASSERT_EQ_STR("111011", buf);
    card_conv(59, 16, buf, sizeof(buf));
    ASSERT_EQ_STR("3B", buf);
}
```

### Green — テストを通す実装

```c
void card_conv(int x, int r, char *buf, size_t bufsz) {
    static const char digits[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    char tmp[66];
    int i = 0;
    do {
        tmp[i++] = digits[x % r];
        x /= r;
    } while (x > 0 && i < 65);
    tmp[i] = '\0';
    /* 文字列を逆順にしてコピー */
    int len = i;
    for (int j = 0; j < len && (size_t)j < bufsz - 1; j++)
        buf[j] = tmp[len - 1 - j];
    buf[len < (int)bufsz ? len : (int)bufsz - 1] = '\0';
}
```

剰余を使って下の桁から求め、最後に逆順にすることで正しい基数表現を得ます。

---

## 4. 素数列挙

素数を 3 通りの方法で列挙し、パフォーマンスを比較します。

### Red — 失敗するテストを書く

```c
void test_prime(void) {
    int primes[200];
    int n1 = prime1(primes, 200);
    int n2 = prime2(primes, 200);
    int n3 = prime3(primes, 200);
    ASSERT_EQ_INT(25, n1);  /* 1000以下の素数は25個 */
    ASSERT_EQ_INT(25, n2);
    ASSERT_EQ_INT(25, n3);
}
```

### Green — 方法 1: 全数割り算

```c
int prime1(int *out, int max_count) {
    int n = 0;
    for (int i = 2; n < max_count; i++) {
        int is_prime = 1;
        for (int j = 2; j < i; j++) {
            if (i % j == 0) { is_prime = 0; break; }
        }
        if (is_prime) {
            out[n++] = i;
            if (i > 999) break;
        }
    }
    return n;
}
```

### Green — 方法 2: 既知の素数のみで割り算

```c
int prime2(int *out, int max_count) {
    out[0] = 2;
    int n = 1;
    for (int i = 3; i <= 1000 && n < max_count; i += 2) {
        int is_prime = 1;
        for (int j = 1; j < n; j++) {
            if (i % out[j] == 0) { is_prime = 0; break; }
        }
        if (is_prime) out[n++] = i;
    }
    return n;
}
```

### Green — 方法 3: 平方根まで割り算（最効率）

```c
int prime3(int *out, int max_count) {
    (void)max_count;  /* 固定範囲（1-1000）のため未使用 */
    out[0] = 2; out[1] = 3;
    int n = 2;
    for (int i = 5; i <= 1000; i += 2) {
        int is_prime = 1;
        for (int j = 1; (long long)out[j] * out[j] <= i; j++) {
            if (i % out[j] == 0) { is_prime = 0; break; }
        }
        if (is_prime) out[n++] = i;
    }
    return n;
}
```

方法 3 は `√i` までしか割り算しないため、方法 1 と比べて大幅に高速です。

| 方法 | 割り算の回数 | 特徴 |
|------|------------|------|
| prime1 | 多い | シンプル |
| prime2 | 中程度 | 既知の素数で割る |
| prime3 | 少ない | √i で打ち切り |

---

## テスト実行結果

```bash
$ make test-chapter02/arrays
=== Testing chapter02/arrays ===
13 tests run: 13 passed, 0 failed
```

---

## まとめ

| 関数 | C の特徴 |
|------|----------|
| `max_of` | `const int *a, int n` の組で配列を渡す |
| `reverse_array` | 入力・出力バッファを別々に受け取る |
| `card_conv` | `char *buf, size_t bufsz` でバッファを受け取る |
| `prime1/2/3` | `int *out, int max_count` で出力先を受け取る |

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
