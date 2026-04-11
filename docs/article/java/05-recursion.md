# 第 5 章 再帰アルゴリズム

## はじめに

この章では再帰の基本パターン（階乗、最大公約数）から応用（ハノイの塔、迷路探索、8 王妃問題）まで TDD で実装します。

---

## 1. 階乗

```java
public static int factorial(int n) {
    if (n <= 0) return 1;
    return n * factorial(n - 1);
}
```

---

## 2. 最大公約数（ユークリッドの互除法）

```java
public static int gcd(int x, int y) {
    if (y == 0) return x;
    return gcd(y, x % y);
}
```

---

## 3. ハノイの塔

```java
public static List<String> hanoi(int n, String src, String dst, String via) {
    List<String> moves = new ArrayList<>();
    hanoiHelper(n, src, dst, via, moves);
    return moves;
}
```

n 枚の場合、移動回数は $2^n - 1$ 回です。

---

## 4. 8 王妃問題

段階的に制約を追加して解を絞り込みます。

| 版 | 制約 | 解の数 |
|----|------|--------|
| EightQueen | なし | $8^8 = 16,777,216$ |
| EightQueen2 | 行制約 | $8! = 40,320$ |
| EightQueen3 | 行・対角線制約 | 92 |

---

## テスト実行結果

```
RecursionTest > FactorialTest > factorial_5() PASSED
RecursionTest > GcdTest > 基本() PASSED
RecursionTest > HanoiTest > ハノイ3枚は7手() PASSED
RecursionTest > EightQueenTest > 完全解は92通り() PASSED
```
