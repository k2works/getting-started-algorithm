# 第 3 章 探索アルゴリズム

## はじめに

この章では線形探索、二分探索、ハッシュ法（チェイン法・オープンアドレス法）を TDD で実装します。

---

## 1. 線形探索

### while 文版

```java
public static int linearSearchWhile(int[] a, int key) {
    int i = 0;
    while (true) {
        if (i == a.length) return -1;
        if (a[i] == key) return i;
        i++;
    }
}
```

### 番兵法

配列末尾に探索キーを追加することで、ループ内の境界チェックを省略します。

```java
public static int linearSearchSentinel(int[] a, int key) {
    int[] b = Arrays.copyOf(a, a.length + 1);
    b[a.length] = key;
    int i = 0;
    while (b[i] != key) i++;
    return i == a.length ? -1 : i;
}
```

---

## 2. 二分探索

ソート済み配列に対して、中央値との比較で探索範囲を半分に狭めます。

```java
public static int binarySearch(int[] a, int key) {
    int pl = 0, pr = a.length - 1;
    while (pl <= pr) {
        int pc = (pl + pr) / 2;
        if (a[pc] == key) return pc;
        else if (a[pc] < key) pl = pc + 1;
        else pr = pc - 1;
    }
    return -1;
}
```

---

## 3. ハッシュ法

### チェイン法

衝突を連結リストで解決します。

### オープンアドレス法（線形探索法）

衝突時に次のバケットを探索します。バケットの状態を `OCCUPIED` / `EMPTY` / `DELETED` の 3 状態で管理します。

---

## Python との比較

| 概念 | Python | Java |
|------|--------|------|
| 配列コピー | `a[:]` | `Arrays.copyOf(a, a.length)` |
| ハッシュ値 | `hashlib.sha256(...)` | `key % capacity`（int キーの場合） |

---

## テスト実行結果

```
SearchTest > LinearSearchTest > while文で探索_見つかる() PASSED
SearchTest > LinearSearchTest > 番兵法で探索_見つかる() PASSED
SearchTest > BinarySearchTest > 中央の要素を探索() PASSED
SearchTest > ChainedHashTest > 探索_見つかる() PASSED
SearchTest > OpenHashTest > 探索_見つかる() PASSED
```
