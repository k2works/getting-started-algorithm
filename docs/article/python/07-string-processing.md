# 第 7 章 文字列処理

## はじめに

前章ではソートアルゴリズムを学びました。この章では、プログラミングにおいて非常に重要な「文字列処理」について TDD で実装します。

文字列処理は、テキストデータの操作や解析に欠かせない技術です。特に、テキスト検索、パターンマッチング、データ抽出などの処理は、多くのアプリケーションで必要とされます。

この章では、まず Python における基本的な文字列操作について学び、その後、テスト駆動開発の手法を用いて、効率的な文字列検索アルゴリズムを実装していきます。

### 目次

1. [Python の文字列基本操作](#python-の文字列基本操作)
2. [ブルートフォース文字列探索（力まかせ法）](#1-ブルートフォース文字列探索)
3. [KMP 法](#2-kmp-法)
4. [Boyer-Moore 法](#3-boyer-moore-法)
5. [文字カウント・逆順・回文判定](#4-文字カウント逆順回文判定)

---

## Python の文字列基本操作

Python では、文字列は不変（immutable）なシーケンス型のオブジェクトとして扱われます。文字列を操作するための豊富なメソッドが用意されており、これらを使うことで様々な文字列処理を簡単に行うことができます。

### 文字列の生成と基本操作

```python
# 文字列の生成
s1 = "Hello"
s2 = 'World'
s3 = """This is a
multiline string"""

# 文字列の連結
s = s1 + " " + s2  # "Hello World"

# 文字列の繰り返し
s = s1 * 3  # "HelloHelloHello"

# 文字列の長さ
length = len(s1)  # 5

# 文字へのアクセス
first_char = s1[0]  # "H"
last_char = s1[-1]  # "o"

# スライス
substring = s1[1:4]  # "ell"
```

### 文字列のメソッド

Python の文字列には、多くの便利なメソッドが用意されています：

```python
s = "Hello, World!"

# 検索
pos = s.find("World")  # 7
pos = s.find("Python")  # -1（見つからない場合）

# 置換
new_s = s.replace("World", "Python")  # "Hello, Python!"

# 分割
parts = s.split(", ")  # ["Hello", "World!"]

# 結合
joined = ", ".join(["Hello", "World"])  # "Hello, World"

# 大文字・小文字変換
upper = s.upper()  # "HELLO, WORLD!"
lower = s.lower()  # "hello, world!"

# 先頭・末尾の処理
stripped = "  Hello  ".strip()  # "Hello"
starts = s.startswith("Hello")  # True
ends = s.endswith("World!")  # True
```

### 文字列のフォーマット

Python では、文字列のフォーマットにいくつかの方法があります：

```python
# % 演算子
name = "Alice"
age = 30
s = "Name: %s, Age: %d" % (name, age)  # "Name: Alice, Age: 30"

# format メソッド
s = "Name: {}, Age: {}".format(name, age)  # "Name: Alice, Age: 30"
s = "Name: {name}, Age: {age}".format(name=name, age=age)  # "Name: Alice, Age: 30"

# f-string（Python 3.6 以降）
s = f"Name: {name}, Age: {age}"  # "Name: Alice, Age: 30"
```

これらの基本的な文字列操作を理解した上で、より高度な文字列検索アルゴリズムを見ていきましょう。

---

## 1. ブルートフォース文字列探索

テキストを左から順にパターンと比較する最もシンプルな方法です。

### Red — 失敗するテストを書く

```python
# tests/test_strings.py
class TestBfMatch:
    def test_found(self):
        assert bf_match("ABCXDEZCABACABAB", "ABAB") == 12

    def test_not_found(self):
        assert bf_match("ABCDE", "XYZ") == -1
```

### Green — テストを通す実装

```python
# src/algorithm/strings.py
def bf_match(text: str, pattern: str) -> int:
    """ブルートフォース文字列探索"""
    n, m = len(text), len(pattern)
    if m == 0:
        return 0
    for i in range(n - m + 1):
        j = 0
        while j < m and text[i + j] == pattern[j]:
            j += 1
        if j == m:
            return i
    return -1
```

### 解説

力まかせ法（ブルートフォース法）のアルゴリズムは以下の通りです：

1. テキスト内の各位置から順にパターンとの一致を調べる
2. 一致しない文字が見つかったら、テキストのカーソルを 1 つ進めて再度パターンの先頭から比較を始める
3. パターン全体が一致したら、その位置を返す

**計算量**:
- 最良の場合：O(m)（m はパターンの長さ）
- 最悪の場合：O(n × m)（n はテキストの長さ）
- 平均の場合：O(n × m)

力まかせ法は単純で理解しやすいですが、テキストとパターンが長い場合には効率が悪くなります。そこで、より効率的なアルゴリズムが開発されました。

### フローチャート

```plantuml
@startuml
title 力まかせ法による文字列検索 (bf_match)

start
:入力: テキスト txt, パターン pat;
:pt = 0; // txt をなぞるカーソル
:pp = 0; // pat をなぞるカーソル

while (pt < len(txt) && pp < len(pat)) is (ループ継続)
  if (txt[pt] == pat[pp]) then (はい)
    :pt += 1;
    :pp += 1;
  else (いいえ)
    :pt = pt - pp + 1;
    :pp = 0;
  endif
endwhile (ループ終了)

if (pp == len(pat)) then (はい)
  :return pt - pp;
else (いいえ)
  :return -1;
endif

stop
@enduml
```

アルゴリズムの流れ：
1. テキスト txt とパターン pat を入力として受け取ります
2. 変数 pt を 0 で初期化します（txt をなぞるカーソル）
3. 変数 pp を 0 で初期化します（pat をなぞるカーソル）
4. pt が txt の長さ未満かつ pp が pat の長さ未満である間、以下の処理を繰り返します：
   - txt[pt] と pat[pp] が一致する場合：両方のカーソルを進めます
   - 一致しない場合：pt を pt - pp + 1 に更新し（次の比較開始位置）、pp を 0 にリセットします
5. ループ終了後、pp が pat の長さと等しい場合：pt - pp を返します（パターンが見つかった位置）
6. それ以外の場合：-1 を返します

---

## 2. KMP 法

KMP 法（Knuth-Morris-Pratt 法）は、力まかせ法を改良した効率的な文字列検索アルゴリズムです。失敗関数テーブル（スキップテーブル）を使い、不一致が発生した際にスキップ量を最適化します。パターン内の情報を利用して、不要な比較を省略します。

### Red — 失敗するテストを書く

```python
class TestKmpMatch:
    def test_found(self):
        assert kmp_match("ABCXDEZCABACABAB", "ABAB") == 12

    def test_not_found(self):
        assert kmp_match("ABCDE", "XYZ") == -1
```

### Green — テストを通す実装

```python
def _build_kmp_table(pattern: str) -> list[int]:
    """失敗関数テーブルを構築"""
    m = len(pattern)
    table = [0] * m
    k = 0
    for i in range(1, m):
        while k > 0 and pattern[k] != pattern[i]:
            k = table[k - 1]
        if pattern[k] == pattern[i]:
            k += 1
        table[i] = k
    return table


def kmp_match(text: str, pattern: str) -> int:
    """KMP 文字列探索"""
    n, m = len(text), len(pattern)
    if m == 0:
        return 0
    table = _build_kmp_table(pattern)
    j = 0
    for i in range(n):
        while j > 0 and text[i] != pattern[j]:
            j = table[j - 1]
        if text[i] == pattern[j]:
            j += 1
        if j == m:
            return i - m + 1
    return -1
```

### 解説

KMP 法の核心は、パターン内の情報を利用して「スキップテーブル」を作成し、不一致が発生した場合に効率的にカーソルを移動させることです。

スキップテーブルは、パターン内の部分文字列が一致する場合に、どこまで戻ればよいかを示します。これにより、すでに比較した文字を再度比較する必要がなくなります。

**計算量**:
- 最良の場合：O(m)（m はパターンの長さ）
- 最悪の場合：O(n + m)（n はテキストの長さ）
- 平均の場合：O(n + m)

KMP 法は、力まかせ法よりも効率的ですが、スキップテーブルの作成と理解が複雑です。

### フローチャート

KMP 法は 2 つの主要なステップから成ります：スキップテーブルの作成と実際の検索です。

#### スキップテーブルの作成

```plantuml
@startuml
title KMP 法 - スキップテーブルの作成

start
:入力: パターン pat;
:pt = 1; // pat をなぞるカーソル
:pp = 0; // pat をなぞる別のカーソル
:skip[len(pat) + 1] = 0 の配列;
:skip[pt] = 0;

while (pt < len(pat)) is (ループ継続)
  if (pat[pt] == pat[pp]) then (はい)
    :pt += 1;
    :pp += 1;
    :skip[pt] = pp;
  elseif (pp == 0) then (はい)
    :pt += 1;
    :skip[pt] = pp;
  else (いいえ)
    :pp = skip[pp];
  endif
endwhile (ループ終了)

:スキップテーブル skip を返す;
stop
@enduml
```

#### 検索処理

```plantuml
@startuml
title KMP 法 - 検索処理

start
:入力: テキスト txt, パターン pat, スキップテーブル skip;
:pt = 0; // txt をなぞるカーソル
:pp = 0; // pat をなぞるカーソル

while (pt < len(txt) && pp < len(pat)) is (ループ継続)
  if (txt[pt] == pat[pp]) then (はい)
    :pt += 1;
    :pp += 1;
  elseif (pp == 0) then (はい)
    :pt += 1;
  else (いいえ)
    :pp = skip[pp];
  endif
endwhile (ループ終了)

if (pp == len(pat)) then (はい)
  :return pt - pp;
else (いいえ)
  :return -1;
endif

stop
@enduml
```

アルゴリズムの流れ：

1. **スキップテーブルの作成**:
   - パターン内の部分文字列が一致する場合に、どこまで戻ればよいかを示すテーブルを作成します
   - パターン自身を使って、パターン内の接頭辞と接尾辞の一致を調べます
   - 一致する最長の接頭辞の長さをスキップテーブルに格納します

2. **検索処理**:
   - テキストとパターンを先頭から比較していきます
   - 文字が一致する場合は、両方のカーソルを進めます
   - 不一致が発生した場合：
     - パターンのカーソルが先頭（pp = 0）なら、テキストのカーソルだけを進めます
     - それ以外の場合は、スキップテーブルを使ってパターンのカーソルを効率的に移動させます
   - パターン全体が一致したら、その位置を返します

KMP 法の大きな利点は、不一致が発生した場合でも、すでに比較した情報を活用してパターンのカーソルを効率的に移動させることです。時間計算量は O(n + m) となり、テキストとパターンが長い場合に特に効果的です。

---

## 3. Boyer-Moore 法

Boyer-Moore 法は、さらに効率的な文字列検索アルゴリズムです。パターンを右から左へ比較し、不一致が発生した場合に大きくスキップすることで、多くの比較を省略します。

### Red — 失敗するテストを書く

```python
class TestBmMatch:
    def test_found(self):
        assert bm_match("ABCXDEZCABACABAB", "ABAB") == 12

    def test_not_found(self):
        assert bm_match("ABCDE", "XYZ") == -1
```

### Green — テストを通す実装

```python
def bm_match(text: str, pattern: str) -> int:
    """Boyer-Moore 文字列探索（Bad Character ルール）"""
    n, m = len(text), len(pattern)
    if m == 0:
        return 0
    bad_char: dict[str, int] = {}
    for i, c in enumerate(pattern):
        bad_char[c] = i
    s = 0
    while s <= n - m:
        j = m - 1
        while j >= 0 and pattern[j] == text[s + j]:
            j -= 1
        if j < 0:
            return s
        else:
            skip = j - bad_char.get(text[s + j], -1)
            s += max(1, skip)
    return -1
```

### 解説

Boyer-Moore 法の特徴は以下の通りです：

1. パターンを右から左へ比較する
2. 不一致が発生した場合、以下の 2 つのルールに基づいてスキップする：
   - 不一致文字ルール：テキスト内の不一致文字がパターン内に存在するかどうかに基づいてスキップ
   - 一致接尾辞ルール：パターン内の部分文字列の一致に基づいてスキップ

**計算量**:
- 最良の場合：O(n / m)（n はテキストの長さ、m はパターンの長さ）
- 最悪の場合：O(n × m)
- 平均の場合：O(n)

Boyer-Moore 法は、実用的な文字列検索アルゴリズムとして広く使用されています。特に、パターンが長い場合や、アルファベットの種類が多い場合に効率的です。

### フローチャート

Boyer-Moore 法も 2 つの主要なステップから成ります：スキップテーブルの作成と実際の検索です。

#### スキップテーブルの作成

```plantuml
@startuml
title Boyer-Moore 法 - スキップテーブルの作成

start
:入力: パターン pat;
:skip[256] = 配列;

repeat :pt = 0 から 255 まで;
  :skip[pt] = len(pat);
repeat while (pt < 255)

repeat :pt = 0 から len(pat)-1 まで;
  :skip[ord(pat[pt])] = len(pat) - pt - 1;
repeat while (pt < len(pat)-1)

:スキップテーブル skip を返す;
stop
@enduml
```

#### 検索処理

```plantuml
@startuml
title Boyer-Moore 法 - 検索処理

start
:入力: テキスト txt, パターン pat, スキップテーブル skip;
:pt = len(pat) - 1; // txt をなぞるカーソル

while (pt < len(txt)) is (ループ継続)
  :pp = len(pat) - 1; // pat をなぞるカーソル

  while (txt[pt] == pat[pp]) is (一致)
    if (pp == 0) then (はい)
      :return pt;
      stop
    end
    :pt -= 1;
    :pp -= 1;
  end
  while (不一致)

  :pt += max(skip[ord(txt[pt])], len(pat) - pp);
endwhile (ループ終了)

:return -1;
stop
@enduml
```

アルゴリズムの流れ：

1. **スキップテーブルの作成**:
   - 各文字について、パターン内での最後の出現位置に基づいてスキップ量を決定します
   - デフォルトでは、パターンの長さだけスキップします
   - パターン内に出現する文字については、その位置に基づいてスキップ量を調整します

2. **検索処理**:
   - パターンを右から左へ比較します（パターンの末尾から開始）
   - 文字が一致する限り、両方のカーソルを左に移動します
   - パターン全体が一致したら（pp = 0 になったら）、その位置を返します
   - 不一致が発生した場合：
     - 不一致文字がパターン内にある場合、その位置に基づいてスキップします
     - パターン内にない場合、パターン全体をスキップします

Boyer-Moore 法の大きな特徴は、パターンを右から左へ比較することと、不一致が発生した場合に大きくスキップできることです。理想的な状況では、テキストの文字の多くを比較せずに済むため、非常に効率的です。最良の場合、O(n/m) という驚異的な時間計算量を達成できます。

---

## 4. 文字カウント・逆順・回文判定

```python
def count_chars(s: str) -> dict[str, int]:
    """文字の出現回数をカウント"""
    result: dict[str, int] = {}
    for c in s:
        result[c] = result.get(c, 0) + 1
    return result


def reverse_string(s: str) -> str:
    """文字列を逆順にする"""
    return s[::-1]


def is_palindrome(s: str) -> bool:
    """回文判定"""
    return s == s[::-1]
```

---

## テスト実行結果

```bash
$ uv run pytest tests/test_strings.py -v

...（27 テスト全パス）...

Name                       Stmts   Miss  Cover
----------------------------------------------
src/algorithm/strings.py      65      0   100%
----------------------------------------------
27 passed in 0.17s
```

カバレッジ 100% 達成しました。

---

## 文字列探索アルゴリズムの比較

| アルゴリズム | 計算量 | 特徴 |
|-------------|--------|------|
| ブルートフォース | O(n × m) | シンプル、小規模に有効 |
| KMP 法 | O(n + m) | 最悪でも線形、前処理が必要 |
| Boyer-Moore 法 | O(n / m) 平均 | 大規模テキストで最速 |

## まとめ

この章では、Python における文字列処理について学びました：

1. **基本的な文字列操作** — 文字列の生成、連結、スライス、メソッドなど
2. **文字列検索アルゴリズム**：
   - 力まかせ法（ブルートフォース法） — 最も単純な方法
   - KMP 法 — パターン内の情報を利用して効率化
   - Boyer-Moore 法 — 右から左への比較と大きなスキップで効率化

文字列処理は、テキストデータを扱う多くのアプリケーションで重要な役割を果たします。効率的な文字列検索アルゴリズムを理解することで、大量のテキストデータを効率的に処理することができます。

テスト駆動開発の手法を用いることで、これらの複雑な文字列検索アルゴリズムの正確な実装と理解を深めることができました。

次の章では、リストについて学んでいきましょう。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
