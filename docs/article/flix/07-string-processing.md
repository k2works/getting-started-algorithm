# 第 7 章 文字列処理

## 7.1 はじめに

第 6 章ではソートアルゴリズムを実装しました。この章では、文字列の基本操作と文字列探索を TDD で学びます。ブルートフォース法、KMP 法、Boyer–Moore 法を同じ入力契約で実装し、探索の効率と前処理の違いを比較します。最後に、文字カウント、逆順、回文判定も扱います。

Flix の `String` は不変です。文字を添字で扱う標準 API は UTF-16 の `Char` 単位で動作します。したがって、ここで返す探索位置は UTF-16 コード単位のインデックスです。日本語のかな・漢字のような BMP 文字は 1 単位ですが、絵文字など BMP 外の文字は 2 単位になる場合があります。Python の Unicode コードポイント単位のインデックスとは異なるため、用途に応じて文字単位を選ぶ必要があります。

### この章の TODO リスト

- [x] `String.length`、`String.get`、`String.toList`、`String.init` で基本操作を確認する
- [x] ブルートフォース法で最初の一致位置を探す
- [x] KMP 法で失敗関数（prefix table）を使って比較を再利用する
- [x] Boyer–Moore 法の不一致文字ルールで右から照合する
- [x] 文字カウント、逆順、回文判定を実装する
- [x] 空パターン、未発見、重複接頭辞、日本語をテストする
- [x] UTF-16 インデックスと各実装の時間・領域計算量を比較する

実装は `src/Strings.flix`、テストは `test/TestStrings.flix` に置きます。

## 7.2 Flix の文字列基本操作

Python の文字列メソッドをそのまま移植するのではなく、Flix 標準ライブラリの操作を組み合わせます。

```flix
String.length("Flix")                         // 4
String.get(1, "Flix")                         // 'l'
String.toList("Flix")                         // 'F' :: 'l' :: 'i' :: 'x' :: Nil
String.init(i -> String.get(3 - i, "Flix"), 4) // "xilF"
```

`String.get` のインデックスは 0 から始まります。Python の負のインデックスやスライス構文はありません。`String.toArray(rc, text)` を使うと、同じ文字単位の配列をローカルな `region` に作れます。第 7 章の検索アルゴリズムでは配列を読み取り、検索元の文字列は変更しません。

Flix では検索結果が存在しない状態を `-1` で表す代わりに `Option[Int32]` で表します。たとえば `Some(12)` はインデックス 12 に一致があり、`None` は見つからなかったことを表します。空パターンは各検索関数で `Some(0)` とします。

## 7.3 ブルートフォース法

テキストの各位置を開始点にして、パターンと左から比較します。不一致なら開始点を 1 つ進めて、パターンの先頭からやり直します。

### Red — 最初の一致と不一致をテストする

`test/TestStrings.flix` にテストを追加します。

```flix
@Test
def bfMatch_found(): Unit \ Assert =
    Assert.assertEq(
        expected = Some(12),
        Strings.bfMatch("ABCXDEZCABACABAB", "ABAB")
    )

@Test
def bfMatch_not_found(): Unit \ Assert =
    Assert.assertEq(expected = None, Strings.bfMatch("ABCDE", "XYZ"))
```

### Green — 1 文字ずつ比較する

`src/Strings.flix` に実装します。

```flix
pub def bfMatch(text: String, pattern: String): Option[Int32] =
    let textLength = String.length(text);
    let patternLength = String.length(pattern);
    if (patternLength == 0) {
        Some(0)
    } else if (patternLength > textLength) {
        None
    } else region rc {
        let textChars = String.toArray(rc, text);
        let patternChars = String.toArray(rc, pattern);

        def search(start) =
            if (start > textLength - patternLength) {
                None
            } else {
                def compare(offset) =
                    if (offset >= patternLength) {
                        Some(start)
                    } else if (Array.get(start + offset, textChars) == Array.get(offset, patternChars)) {
                        compare(offset + 1)
                    } else {
                        search(start + 1)
                    };
                compare(0)
            };

        search(0)
    }
```

`start` は次の照合開始位置、`offset` はパターン内の比較位置です。開始位置は `textLength - patternLength` までに限定し、テキスト配列の範囲外を読まないようにします。内側の比較で全 `patternLength` 文字が一致したとき、その開始位置を返します。

最初の位置で一致すれば O(m)、最悪では開始位置ごとに m 文字を比較するため O(nm) です。`String.toArray` による読み取り用コピーを含めると、追加領域は O(n + m) です。小さな入力には単純ですが、同じ接頭辞が何度も現れるテキストでは重複比較が増えます。

## 7.4 KMP 法

KMP 法（Knuth–Morris–Pratt）は、パターン自身に含まれる接頭辞と接尾辞の一致を prefix table に記録します。不一致時にテキスト側を戻さず、パターン側だけを適切な位置へ戻すことで比較を再利用します。

たとえばパターン `ABABAC` の途中まで `ABABA` が一致した後に不一致が起きても、すでに一致した末尾 `ABA` は先頭の `ABA` と一致します。そこでパターンを先頭からやり直さず、prefix table が示す位置から再開します。

### Red — 接頭辞が重なる入力をテストする

```flix
@Test
def kmpMatch_found_after_fallback(): Unit \ Assert =
    Assert.assertEq(
        expected = Some(2),
        Strings.kmpMatch("abababac", "ababac")
    )
```

### Green — prefix table を作って再利用する

```flix
pub def kmpMatch(text: String, pattern: String): Option[Int32] =
    let textLength = String.length(text);
    let patternLength = String.length(pattern);
    if (patternLength == 0) {
        Some(0)
    } else if (patternLength > textLength) {
        None
    } else region rc {
        let textChars = String.toArray(rc, text);
        let patternChars = String.toArray(rc, pattern);
        let prefix = Array.repeat(rc, patternLength, 0);

        def build(i, matched) =
            if (i >= patternLength) {
                ()
            } else {
                def fallback(k) =
                    if (k > 0 and Array.get(k, patternChars) != Array.get(i, patternChars))
                        fallback(Array.get(k - 1, prefix))
                    else
                        k;

                let k = fallback(matched);
                let next = if (Array.get(k, patternChars) == Array.get(i, patternChars)) k + 1 else k;
                Array.put(next, i, prefix);
                build(i + 1, next)
            };

        def search(i, matched) =
            if (i >= textLength) {
                None
            } else {
                def fallback(k) =
                    if (k > 0 and Array.get(i, textChars) != Array.get(k, patternChars))
                        fallback(Array.get(k - 1, prefix))
                    else
                        k;

                let k = fallback(matched);
                if (Array.get(i, textChars) == Array.get(k, patternChars)) {
                    let next = k + 1;
                    if (next == patternLength)
                        Some(i - patternLength + 1)
                    else
                        search(i + 1, next)
                } else {
                    search(i + 1, 0)
                }
            };

        build(1, 0);
        search(0, 0)
    }
```

`prefix[i]` は、`pattern[0..i]` の末尾と先頭が一致する最長の長さです。前処理と検索はそれぞれ償却 O(m)、O(n) なので、合計時間は O(n + m) です。Flix 版ではテキストとパターンの文字配列に加えて prefix table を作るため、追加領域は O(n + m) です。

### Refactor — 日本語と境界値を確かめる

```flix
@Test
def kmpMatch_japanese(): Unit \ Assert =
    Assert.assertEq(expected = Some(3), Strings.kmpMatch("こんにちは世界", "ちは"))

@Test
def kmpMatch_empty_pattern(): Unit \ Assert =
    Assert.assertEq(expected = Some(0), Strings.kmpMatch("", ""))
```

`String.get` と `String.toArray` は同じ UTF-16 `Char` 単位を使うため、かな・漢字を含む文字列でも同じ規則で一致を調べられます。空パターンは prefix table を作る前に処理するため、長さ 0 の配列を不正に参照しません。

## 7.5 Boyer–Moore 法

Boyer–Moore 法はパターンの末尾から左向きに比較します。この章では不一致文字ルール（bad-character rule）のみを実装します。パターン中の各文字の最後の出現位置を Map に記録し、不一致が起きたとき、その文字を揃えられるだけパターンを右へ移動します。

一致接尾辞ルールも組み合わせた完全な Boyer–Moore 実装とは異なるため、ここでは「Boyer–Moore 法の不一致文字ルール」として比較します。

### Red — 右から比較する検索をテストする

```flix
@Test
def bmMatch_found(): Unit \ Assert =
    Assert.assertEq(
        expected = Some(12),
        Strings.bmMatch("ABCXDEZCABACABAB", "ABAB")
    )

@Test
def bmMatch_repeated_pattern_characters(): Unit \ Assert =
    Assert.assertEq(expected = Some(3), Strings.bmMatch("ABAAABCD", "AABC"))
```

### Green — 最後の出現位置に基づいてスキップする

```flix
pub def bmMatch(text: String, pattern: String): Option[Int32] =
    let textLength = String.length(text);
    let patternLength = String.length(pattern);
    if (patternLength == 0) {
        Some(0)
    } else if (patternLength > textLength) {
        None
    } else region rc {
        let textChars = String.toArray(rc, text);
        let patternChars = String.toArray(rc, pattern);

        def buildBadCharacterTable(i, table) =
            if (i >= patternLength) {
                table
            } else {
                let character = Array.get(i, patternChars);
                buildBadCharacterTable(i + 1, Map.insert(character, i, table))
            };

        let badCharacterTable = buildBadCharacterTable(0, Map.empty());

        def search(start) =
            if (start > textLength - patternLength) {
                None
            } else {
                def compare(offset) =
                    if (offset < 0) {
                        Some(start)
                    } else {
                        let textCharacter = Array.get(start + offset, textChars);
                        let patternCharacter = Array.get(offset, patternChars);
                        if (textCharacter == patternCharacter) {
                            compare(offset - 1)
                        } else {
                            let lastOccurrence = match Map.get(textCharacter, badCharacterTable) {
                                case None => -1
                                case Some(index) => index
                            };
                            let shift = if (offset - lastOccurrence > 1) offset - lastOccurrence else 1;
                            search(start + shift)
                        }
                    };
                compare(patternLength - 1)
            };

        search(0)
    }
```

不一致文字がパターンに現れない場合は `lastOccurrence` が `-1` となり、パターン長に相当する距離を進められます。最後の出現位置が不一致位置より右にある場合も、最低 1 文字は進めます。Map への登録にはパターンを左から走査するため、同じ文字が複数回あれば最後の位置が残ります。

この実装は前処理に O(m log k)、追加領域 O(n + m + k) を使います。k はパターン中の異なる文字数で、Map の探索・更新を O(log k) とした場合です。不一致文字ルールだけでは最悪 O(nm) であり、最悪 O(n + m) を保証しません。パターンや文字の分布によって大きくスキップできることが利点です。

## 7.6 文字カウント・逆順・回文判定

文字列を文字のリストへ変換する `String.toList` と、不変 Map を組み合わせて出現回数を数えます。

```flix
pub def countChars(s: String): Map[Char, Int32] =
    def countOccurrences(chars, counts) = match chars {
        case Nil => counts
        case character :: rest =>
            let nextCount = match Map.get(character, counts) {
                case None => 1
                case Some(currentCount) => currentCount + 1
            };
            countOccurrences(rest, Map.insert(character, nextCount, counts))
    };
    countOccurrences(String.toList(s), Map.empty())
```

`String.init` で各位置から反対側の位置を取り出すと、逆順の文字列を作れます。回文判定では新しい文字列を作らず、左右の文字を内側へ向かって比較します。

```flix
pub def reverseString(s: String): String =
    let length = String.length(s);
    String.init(i -> String.get(length - i - 1, s), length)

pub def isPalindrome(s: String): Bool =
    let last = String.length(s) - 1;
    def compare(left, right) =
        if (left >= right)
            true
        else if (String.get(left, s) == String.get(right, s))
            compare(left + 1, right - 1)
        else
            false;
    compare(0, last)
```

これらの操作も UTF-16 `Char` 単位です。大文字・小文字、空白、句読点の正規化は行わず、入力された単位列をそのまま比較します。`reverseString` は UTF-16 の surrogate pair を分離する可能性があるため、BMP 外の文字を含む文章の表示用反転には使わないでください。Unicode コードポイントや書記素クラスタを扱う必要がある場合は、別の文字走査方式が必要です。

## 7.7 テストと計算量の比較

`test/TestStrings.flix` では、通常の一致・不一致に加えて、空パターン、パターンがテキストより長い場合、重複する接頭辞、Map による文字カウント、日本語のかな・漢字を確認します。

```bash
make test
make check
make format-check
```

| アルゴリズム | 前処理 | 検索時間 | 追加領域 | 特徴 |
|---|---:|---:|---:|---|
| ブルートフォース法 | なし | 最良 O(m)、最悪 O(nm) | O(n + m) | 最も単純。部分一致を再比較する |
| KMP 法 | O(m) | O(n) | O(n + m) | prefix table で比較を再利用し、最悪でも線形 |
| Boyer–Moore（不一致文字ルール） | O(m log k) | 最悪 O(nm) | O(n + m + k) | 末尾から比較し、文字分布によって大きくスキップ |

ここで n はテキスト長、m はパターン長、k はパターン中の異なる文字数です。Flix 版では `String.toArray` による文字単位配列の作成も領域に含めました。Map 操作は O(log k) として見積もっています。ブルートフォース法の最悪時間は、同じ接頭辞を何度も照合する入力で生じます。KMP 法はその再比較を避ける一方、prefix table の構築が必要です。Boyer–Moore の本章版は不一致文字ルールのみなので、最悪計算量が線形になるとは限りません。

## 7.8 まとめ

この章では Flix の不変な `String` を UTF-16 `Char` の列として扱い、基本的なアクセスと変換を確認しました。3 種の文字列探索では、単純な再比較、prefix table による再利用、不一致文字による右向きのスキップを比較しました。検索結果を `Option[Int32]` で表すことで、見つからない状態と有効な位置を型で区別しています。

日本語を含む BMP 文字列は同じ `Char` 単位で探索・カウントできます。一方、Python と Flix ではインデックスの単位が異なり、絵文字など BMP 外の文字では Flix の操作が Unicode コードポイント単位ではない点に注意してください。

次章ではリストを扱い、標準の不変 `List` とノードを使うリスト構造を比較します。
