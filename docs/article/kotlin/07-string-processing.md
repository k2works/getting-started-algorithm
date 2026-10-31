# 第 7 章 文字列処理

## はじめに

前章ではソートアルゴリズムを学びました。この章では、文字列の基本操作と文字列探索を TDD の Red → Green → Refactor で実装します。探索方法は、力まかせ法、KMP 法、Boyer–Moore 法（不一致文字ルール）の 3 種類です。

Kotlin の `String` は Java と同じ UTF-16 のコード単位を使います。そのため `length`、`String[index]`、探索結果の位置は UTF-16 コード単位の数・添字です。一方、この章の出現回数、反転、回文判定は Unicode code point 単位で処理します。たとえば `"A😀B"` の `length` は 4、code point 数は 3 です。探索結果は Kotlin の文字列 API と揃え、`"B"` の位置を 3 として返します。

code point は利用者が認識する見た目上の「一文字」（書記素クラスタ）と必ずしも一致しません。たとえば、基底文字と結合文字からなる表記は複数の code point です。この章では書記素クラスタ単位の処理までは扱いません。

## 7.1 Red: 文字列処理の契約をテストする

まず、空文字列や補助平面の文字、日本語を含むテストで基本操作の単位を固定します。3 つの探索アルゴリズムには同じ入力を与え、先頭・末尾・未発見・空パターンに加えて、KMP が活用する重複接頭辞と UTF-16 の位置も確認します。

```kotlin
@Test
fun `string length counts UTF-16 code units`() {
    assertEquals(0, StringProcessingAlgorithms.stringLength(""))
    assertEquals(5, StringProcessingAlgorithms.stringLength("A😀日本"))
}

@Test
fun `search algorithms find patterns and return UTF-16 indices`() {
    val cases = listOf(
        Triple("ABCXDEZCABACABAB", "ABAB", 12),
        Triple("aaaaab", "aaab", 2),
        Triple("日本語の文字列", "文字", 4),
        Triple("A😀B", "B", 3),
        Triple("ABCDE", "XYZ", -1),
        Triple("ABCDE", "", 0),
    )

    for ((_, search) in searches) {
        for ((text, pattern, expected) in cases) {
            assertEquals(expected, search(text, pattern))
        }
    }
}
```

`StringProcessingAlgorithmsTest` では、さらに文字カウント、補助平面文字を壊さない反転、空文字列や日本語を含む回文判定もテストしています。探索関数の戻り値は、最初に一致した UTF-16 添字です。空パターンなら 0、見つからなければ `-1` を返します。

## 7.2 Green: 文字列の基本操作を実装する

```kotlin
fun stringLength(text: String): Int = text.length

fun countCharacters(text: String): Map<String, Int> {
    val counts = linkedMapOf<String, Int>()
    var index = 0
    while (index < text.length) {
        val codePoint = text.codePointAt(index)
        val character = String(Character.toChars(codePoint))
        counts[character] = (counts[character] ?: 0) + 1
        index += Character.charCount(codePoint)
    }
    return counts
}

fun reverse(text: String): String {
    val result = StringBuilder(text.length)
    var index = text.length
    while (index > 0) {
        val codePoint = text.codePointBefore(index)
        result.appendCodePoint(codePoint)
        index -= Character.charCount(codePoint)
    }
    return result.toString()
}

fun isPalindrome(text: String): Boolean = text == reverse(text)
```

`length` は UTF-16 コード単位数です。これに対し `codePointAt` と `codePointBefore` を使う 3 つのユーティリティは、サロゲートペアを 1 つの code point として扱います。文字列反転で単純に `Char` を逆順にすると、補助平面文字のサロゲートペアが分離して不正な文字列になるため、code point ごとに後ろから読み取ります。

文字カウント、反転、回文判定はいずれも O(n) 時間です。カウントは異なる code point 数に応じた O(k) 領域、反転と回文判定は結果文字列のため O(n) 領域を使います。

## 7.3 力まかせ法で探索する

力まかせ法は、本文の各位置を開始位置としてパターン全体を左から比較します。1 文字でも異なれば、開始位置を 1 つ進めます。

```kotlin
fun bruteForceSearch(text: String, pattern: String): Int {
    val textLength = text.length
    val patternLength = pattern.length
    if (patternLength == 0) return 0

    for (start in 0..textLength - patternLength) {
        var matched = 0
        while (matched < patternLength && text[start + matched] == pattern[matched]) {
            matched++
        }
        if (matched == patternLength) return start
    }
    return -1
}
```

`String` の添字で直接比較するため、探索も UTF-16 コード単位で行います。パターン長が本文より長いときは、開始位置の範囲が空になり `-1` を返します。最悪時間計算量は O(n × m)、追加領域は O(1) です。

## 7.4 KMP 法で不一致を効率化する

KMP 法は、パターンの各位置までにある「真の接頭辞かつ接尾辞」の最長の長さを表にします。不一致が起きても、すでに一致していた部分の情報を使い、本文側を後戻りさせずに比較を続けます。

```kotlin
private fun buildKmpTable(pattern: String): IntArray {
    val prefixLengths = IntArray(pattern.length)
    var prefixLength = 0
    for (index in 1 until pattern.length) {
        while (prefixLength > 0 && pattern[index] != pattern[prefixLength]) {
            prefixLength = prefixLengths[prefixLength - 1]
        }
        if (pattern[index] == pattern[prefixLength]) prefixLength++
        prefixLengths[index] = prefixLength
    }
    return prefixLengths
}

fun kmpSearch(text: String, pattern: String): Int {
    if (pattern.isEmpty()) return 0
    val prefixLengths = buildKmpTable(pattern)
    var matched = 0
    for (index in text.indices) {
        while (matched > 0 && text[index] != pattern[matched]) {
            matched = prefixLengths[matched - 1]
        }
        if (text[index] == pattern[matched]) matched++
        if (matched == pattern.length) return index - pattern.length + 1
    }
    return -1
}
```

たとえばパターン `"ABAB"` の表は `[0, 0, 1, 2]` です。末尾で不一致になった場合、すでに一致した `"ABA"` の接頭辞・接尾辞 `"A"` を再利用できます。前処理と検索を合わせた時間計算量は O(n + m)、表に必要な追加領域は O(m) です。

## 7.5 Boyer–Moore 法で右から比較する

Boyer–Moore 法はパターンの末尾から比較し、不一致が起きたときにパターンを右へ移動します。ここでは実装を明確にするため、不一致文字ルールを使います。パターン内の各文字について最後の出現位置を記録し、不一致文字がその位置と重なるようにずらします。移動量は最低 1 とします。

```kotlin
fun boyerMooreSearch(text: String, pattern: String): Int {
    val textLength = text.length
    val patternLength = pattern.length
    if (patternLength == 0) return 0

    val lastOccurrence = mutableMapOf<Char, Int>()
    for (index in pattern.indices) {
        lastOccurrence[pattern[index]] = index
    }

    var start = 0
    while (start <= textLength - patternLength) {
        var patternIndex = patternLength - 1
        while (patternIndex >= 0 && pattern[patternIndex] == text[start + patternIndex]) {
            patternIndex--
        }
        if (patternIndex < 0) return start

        val mismatch = text[start + patternIndex]
        val previousOccurrence = lastOccurrence[mismatch] ?: -1
        start += (patternIndex - previousOccurrence).coerceAtLeast(1)
    }
    return -1
}
```

この実装は不一致文字ルールのみを採用し、一致した接尾辞を使うルールは含みません。前処理は平均 O(m)、領域は O(k)（パターン内の異なる UTF-16 コード単位数）です。検索の最悪時間は O(n × m) ですが、不一致文字に応じて複数位置を飛ばせる場合があります。

## 7.6 計算量と仕様の比較

ここで `n` は本文の UTF-16 コード単位数、`m` はパターンの UTF-16 コード単位数です。探索位置も UTF-16 添字で返します。

| 処理 | 時間計算量 | 追加領域 | 単位・仕様 |
|:---|:---:|:---:|:---|
| 文字列長 | O(1) | O(1) | UTF-16 コード単位数 |
| 文字カウント | O(n) | O(k) | Unicode code point 単位 |
| 反転・回文判定 | O(n) | O(n) | Unicode code point 単位 |
| 力まかせ探索 | 最悪 O(n × m) | O(1) | UTF-16 コード単位、最初の一致 |
| KMP 法 | O(n + m) | O(m) | UTF-16 コード単位、最初の一致 |
| Boyer–Moore 法 | 最悪 O(n × m) | O(k) | 不一致文字ルール、UTF-16 コード単位 |

`k` はカウント対象またはパターンに含まれる異なる要素数です。Kotlin の文字列 API と位置を揃えつつ、見た目上 1 文字の補助平面文字を不正に分割しないよう、基本操作と探索で単位を使い分けています。API を使う側は、この違いを意識してください。

## テストの実行

リポジトリルートで Nix 環境に入り、Kotlin アプリケーションの対象テストを実行します。

```bash
nix develop .#kotlin
cd apps/kotlin
./gradlew test --tests algorithm.StringProcessingAlgorithmsTest
```

## まとめ

この章では、文字列長、文字カウント、反転、回文判定と、力まかせ法・KMP 法・Boyer–Moore 法を実装しました。アルゴリズムの計算量だけでなく、Kotlin `String` の UTF-16 添字と Unicode code point の違いもテストで確認しました。次章では、リストのデータ構造を学びます。
