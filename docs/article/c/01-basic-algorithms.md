# 第 1 章 基本的なアルゴリズム

## はじめに

この章では、C 言語を使って基本的なアルゴリズムを学びながら、テスト駆動開発（TDD）の手法で実装します。

C 言語は低水準の制御が可能な言語であり、アルゴリズムの動作原理を理解するのに最適です。ポインタ、配列、構造体を直接操作することで、メモリとデータの関係を体感できます。

## 準備

### 環境構築

```bash
# Nix 環境に入る（gcc + make が利用可能になる）
nix develop .#c

# プロジェクトディレクトリへ移動
cd apps/c
```

### プロジェクト構成

```
apps/c/
├── Makefile
├── include/
│   └── test_helper.h        # テストマクロ
└── chapter01/
    ├── basic_algorithms.h   # ヘッダ
    ├── basic_algorithms.c   # 実装
    └── basic_algorithms_test.c  # テスト
```

### テスト実行コマンド

```bash
# 全章テスト
make test

# 特定章のテスト
make test-chapter01/basic_algorithms
```

### テストヘルパー

`include/test_helper.h` に独自のアサートマクロを定義しています：

```c
ASSERT_EQ_INT(expected, actual)   // 整数値の比較
ASSERT_EQ_STR(expected, actual)   // 文字列の比較
ASSERT_TRUE(expr)                 // 真であることの確認
ASSERT_FALSE(expr)                // 偽であることの確認
TEST_SUMMARY()                    // テスト結果の表示
```

---

## 1. 3 値の最大値

3 つの整数値の中から最大値を求めるアルゴリズムを TDD で実装します。

### Red — 失敗するテストを書く

```c
// chapter01/basic_algorithms_test.c
void test_max3(void) {
    ASSERT_EQ_INT(3, max3(3, 2, 1));
    ASSERT_EQ_INT(3, max3(1, 3, 2));
    ASSERT_EQ_INT(3, max3(1, 2, 3));
    ASSERT_EQ_INT(3, max3(3, 3, 3));
}
```

### Green — テストを通す最小限の実装

```c
// chapter01/basic_algorithms.c
int max3(int a, int b, int c) {
    int maximum = a;
    if (b > maximum) maximum = b;
    if (c > maximum) maximum = c;
    return maximum;
}
```

1. 最初の値を最大値と仮定する
2. 残りの値と比較し、より大きければ更新する
3. すべての比較が終わったら最大値を返す

---

## 2. 3 値の中央値

### Red — 失敗するテストを書く

```c
void test_med3(void) {
    ASSERT_EQ_INT(2, med3(3, 2, 1));
    ASSERT_EQ_INT(2, med3(1, 3, 2));
    ASSERT_EQ_INT(2, med3(1, 2, 3));
}
```

### Green — テストを通す最小限の実装

```c
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
```

| 条件 | 中央値 |
|------|--------|
| a >= b かつ b >= c | b |
| a >= b かつ a <= c | a |
| a >= b（それ以外） | c |
| a < b かつ a > c | a |
| a < b かつ b > c | c |
| それ以外 | b |

---

## 3. 条件判定と分岐

### Red — 失敗するテストを書く

```c
void test_judge_sign(void) {
    ASSERT_EQ_STR("positive", judge_sign(17));
    ASSERT_EQ_STR("negative", judge_sign(-5));
    ASSERT_EQ_STR("zero",     judge_sign(0));
}
```

### Green — テストを通す最小限の実装

```c
const char *judge_sign(int n) {
    if (n > 0) return "positive";
    else if (n < 0) return "negative";
    else return "zero";
}
```

C では文字列を戻り値として返す場合、文字列リテラル（静的メモリ）へのポインタを返します。

---

## 4. 繰り返し処理 — 1 から n までの総和

### Red — 失敗するテストを書く

```c
void test_sum_1_to_n(void) {
    ASSERT_EQ_INT(15, sum_1_to_n(5));
    ASSERT_EQ_INT(1,  sum_1_to_n(1));
    ASSERT_EQ_INT(0,  sum_1_to_n(0));
}
```

### Green — テストを通す最小限の実装

```c
int sum_1_to_n(int n) {
    int total = 0;
    for (int i = 1; i <= n; i++)
        total += i;
    return total;
}
```

---

## 5. 記号文字の交互表示

### Red — 失敗するテストを書く

```c
void test_alternative(void) {
    char buf[32];
    alternative(12, buf, sizeof(buf));
    ASSERT_EQ_STR("+-+-+-+-+-+-", buf);
}
```

### Green — テストを通す最小限の実装

```c
void alternative(int n, char *buf, size_t bufsz) {
    for (int i = 0; i < n && (size_t)i < bufsz - 1; i++)
        buf[i] = (i % 2 == 0) ? '+' : '-';
    buf[n < (int)bufsz ? n : (int)bufsz - 1] = '\0';
}
```

C では文字列をバッファ（`char *buf`）として受け取るパターンが標準的です。バッファサイズ（`bufsz`）を必ず渡して、バッファオーバーフローを防ぎます。

---

## 6. 多重ループ — 九九の表

### Red — 失敗するテストを書く

```c
void test_multiplication_table(void) {
    char buf[1024];
    multiplication_table(buf, sizeof(buf));
    ASSERT_TRUE(strstr(buf, "  1  2  3") != NULL);
}
```

### Green — テストを通す最小限の実装

```c
void multiplication_table(char *buf, size_t bufsz) {
    int pos = 0;
    pos += snprintf(buf + pos, bufsz - pos, "---------------------------\n");
    for (int i = 1; i <= 9; i++) {
        for (int j = 1; j <= 9; j++)
            pos += snprintf(buf + pos, bufsz - pos, "%3d", i * j);
        pos += snprintf(buf + pos, bufsz - pos, "\n");
    }
    snprintf(buf + pos, bufsz - pos, "---------------------------");
}
```

`snprintf` は書式付き文字列を安全にバッファへ書き込む関数です。戻り値（書き込んだ文字数）を `pos` に加算することで、次の書き込み位置を進めます。

---

## テスト実行結果

```bash
$ make test-chapter01/basic_algorithms
=== Testing chapter01/basic_algorithms ===
17 tests run: 17 passed, 0 failed
```

---

## まとめ

| アルゴリズム | 関数 | C の特徴 |
|-------------|------|----------|
| 3 値の最大値 | `max3` | 値渡し |
| 3 値の中央値 | `med3` | 条件分岐 |
| 符号判定 | `judge_sign` | 文字列リテラルへのポインタ |
| 総和 | `sum_1_to_n` | `for` ループ |
| 交互表示 | `alternative` | バッファ渡し（`char *buf, size_t bufsz`） |
| 九九の表 | `multiplication_table` | `snprintf` による文字列構築 |

Python と C の主な違い：

- C は戻り値として文字列を返す場合、呼び出し元がバッファを用意する
- 文字列操作は `<string.h>` の関数群（`snprintf`, `strstr` 等）を使う
- 配列の範囲チェックは自分で行う必要がある

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
