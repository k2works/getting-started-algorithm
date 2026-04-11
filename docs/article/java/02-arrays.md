# 第 2 章 配列

## はじめに

この章では配列の基本操作として、最大値の探索、反転、基数変換、素数列挙を TDD で実装します。

---

## 1. 配列の最大値

```java
public static int maxOf(int[] a) {
    int maximum = a[0];
    for (int i = 1; i < a.length; i++) {
        if (a[i] > maximum) maximum = a[i];
    }
    return maximum;
}
```

---

## 2. 配列の反転

```java
public static void reverse(int[] a) {
    int n = a.length;
    for (int i = 0; i < n / 2; i++) {
        int tmp = a[i];
        a[i] = a[n - i - 1];
        a[n - i - 1] = tmp;
    }
}
```

### Python との比較

| Python | Java |
|--------|------|
| `a[i], a[j] = a[j], a[i]` | `int tmp = a[i]; a[i] = a[j]; a[j] = tmp;` |

---

## 3. 基数変換

```java
public static String cardConv(int x, int r) {
    String dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    StringBuilder d = new StringBuilder();
    while (x > 0) {
        d.append(dchar.charAt(x % r));
        x /= r;
    }
    return d.reverse().toString();
}
```

---

## 4. 素数の列挙

3 つの版を通じて、アルゴリズムの改善がどれだけ効率化に寄与するかを確認します。

| 版 | 除算回数（1000 以下） |
|----|----------------------|
| 第 1 版 | 78,022 |
| 第 2 版 | 14,622 |
| 第 3 版 | 3,774 |

---

## テスト実行結果

```
ArrayAlgorithmsTest > MaxOfTest > 複数要素の最大値() PASSED
ArrayAlgorithmsTest > ReverseArrayTest > 奇数長の配列を反転() PASSED
ArrayAlgorithmsTest > CardConvTest > 二進数変換() PASSED
ArrayAlgorithmsTest > PrimeTest > 素数列挙第1版の除算回数() PASSED
ArrayAlgorithmsTest > PrimeTest > 素数列挙第2版の除算回数() PASSED
ArrayAlgorithmsTest > PrimeTest > 素数列挙第3版の除算回数() PASSED
```
