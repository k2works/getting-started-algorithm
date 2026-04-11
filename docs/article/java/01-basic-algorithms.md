# 第 1 章 基本的なアルゴリズム

## はじめに

この章では Java を使って基本的なアルゴリズムを学びながら、テスト駆動開発（TDD）の手法を用いて実装していきます。Red-Green-Refactor のサイクルを繰り返しながら、確実に動作するコードを段階的に作り上げます。

## 準備

### 環境構築

```bash
nix develop .#java
cd apps/java
gradle test
```

### プロジェクト構成

```
apps/java/
├── build.gradle
├── settings.gradle
└── src/
    ├── main/java/algorithm/
    │   └── BasicAlgorithms.java
    └── test/java/algorithm/
        └── BasicAlgorithmsTest.java
```

---

## 1. 3 値の最大値

### Red -- 失敗するテストを書く

```java
@Test
void 各パターンで最大値を返す() {
    int[][] cases = {
        {3, 2, 1, 3}, {3, 2, 2, 3}, {3, 1, 2, 3},
        {3, 2, 3, 3}, {2, 1, 3, 3}, {3, 3, 2, 3},
        {3, 3, 3, 3}, {2, 2, 3, 3}, {2, 3, 1, 3},
        {2, 3, 2, 3}, {1, 3, 2, 3}, {2, 3, 3, 3},
        {1, 2, 3, 3},
    };
    for (int[] c : cases) {
        assertEquals(c[3], BasicAlgorithms.max3(c[0], c[1], c[2]));
    }
}
```

### Green -- テストを通す最小の実装

```java
public static int max3(int a, int b, int c) {
    int maximum = a;
    if (b > maximum) maximum = b;
    if (c > maximum) maximum = c;
    return maximum;
}
```

---

## 2. 3 値の中央値

```java
public static int med3(int a, int b, int c) {
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

---

## 3. 条件判定と分岐

```java
public static String judgeSign(int n) {
    if (n > 0) return "その値は正です。";
    else if (n < 0) return "その値は負です。";
    else return "その値は0です。";
}
```

---

## 4. 繰り返し処理

### while 文による総和

```java
public static int sum1ToNWhile(int n) {
    int total = 0;
    int i = 1;
    while (i <= n) { total += i; i++; }
    return total;
}
```

### for 文による総和

```java
public static int sum1ToNFor(int n) {
    int total = 0;
    for (int i = 1; i <= n; i++) total += i;
    return total;
}
```

---

## 5. 記号文字の交互表示

```java
public static String alternative1(int n) {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < n; i++) sb.append(i % 2 != 0 ? '-' : '+');
    return sb.toString();
}
```

---

## 6. 九九の表

```java
public static String multiplicationTable() {
    StringBuilder sb = new StringBuilder();
    sb.append("-".repeat(27)).append("\n");
    for (int i = 1; i <= 9; i++) {
        for (int j = 1; j <= 9; j++) sb.append(String.format("%3d", i * j));
        sb.append("\n");
    }
    sb.append("-".repeat(27));
    return sb.toString();
}
```

---

## Python との比較

| 概念 | Python | Java |
|------|--------|------|
| 文字列連結 | `result += "+"` | `sb.append('+')` (StringBuilder) |
| フォーマット | `f"{i * j:3}"` | `String.format("%3d", i * j)` |
| 文字列の繰り返し | `"*" * n` | `"*".repeat(n)` (Java 11+) |
| 整数除算 | `n // 2` | `n / 2`（int 同士） |

## テスト実行結果

```
BasicAlgorithmsTest > Max3Test > 各パターンで最大値を返す() PASSED
BasicAlgorithmsTest > Med3Test > 各パターンで中央値を返す() PASSED
BasicAlgorithmsTest > JudgeSignTest > 正の値() PASSED
BasicAlgorithmsTest > Sum1ToNTest > while文で総和() PASSED
BasicAlgorithmsTest > AlternativeTest > 剰余判定方式で12文字() PASSED
BasicAlgorithmsTest > MultiplicationTableTest > 九九の表() PASSED
BasicAlgorithmsTest > TriangleLbTest > 直角三角形() PASSED
```
