# 第 1 章 基本的なアルゴリズム

## はじめに

この章では、Go を使って基本的なアルゴリズムを学びながら、テスト駆動開発（TDD）の手法を用いて実装していきます。

Go はシンプルな構文と強力な標準ライブラリを持つ言語です。クラスの代わりに `struct` とメソッドを使い、例外の代わりに複数戻り値でエラーを扱います。

## 準備

### 環境構築

```bash
# Nix 環境に入る
nix develop .#go

# プロジェクトディレクトリへ移動
cd apps/go

# テスト実行
go test ./...
```

### プロジェクト構成

```
apps/go/
├── go.mod
├── chapter01/
│   ├── basic_algorithms.go       # 実装ファイル
│   └── basic_algorithms_test.go  # テストファイル
```

### テスト実行コマンド

```bash
# 全テスト実行
go test ./...

# 特定パッケージのみ
go test ./chapter01/...

# 詳細表示
go test -v ./chapter01/...
```

---

## 1. アルゴリズムとは

アルゴリズムとは、問題を解決するための明確な手順のことです。

---

## 2. 3 値の最大値

### Red — 失敗するテストを書く

```go
// chapter01/basic_algorithms_test.go
package chapter01_test

import (
    "testing"
    "github.com/k2works/getting-started-algorithm/go/chapter01"
)

func TestMax3(t *testing.T) {
    tests := []struct {
        a, b, c  int
        expected int
    }{
        {3, 2, 1, 3},
        {1, 2, 3, 3},
    }
    for _, tt := range tests {
        got := chapter01.Max3(tt.a, tt.b, tt.c)
        if got != tt.expected {
            t.Errorf("Max3(%d,%d,%d) = %d; want %d", tt.a, tt.b, tt.c, got, tt.expected)
        }
    }
}
```

### Green — 最小限の実装

```go
// chapter01/basic_algorithms.go
package chapter01

func Max3(a, b, c int) int {
    maximum := a
    if b > maximum {
        maximum = b
    }
    if c > maximum {
        maximum = c
    }
    return maximum
}
```

---

## 3. 3 値の中央値

```go
func Med3(a, b, c int) int {
    if a >= b {
        if b >= c {
            return b
        } else if a <= c {
            return a
        } else {
            return c
        }
    } else if a > c {
        return a
    } else if b > c {
        return c
    } else {
        return b
    }
}
```

---

## 4. 条件判定と分岐

```go
func JudgeSign(n int) string {
    if n > 0 {
        return "その値は正です。"
    } else if n < 0 {
        return "その値は負です。"
    } else {
        return "その値は0です。"
    }
}
```

---

## 5. 繰り返し処理

Go には `while` キーワードがありません。`for` だけで while ループを表現します。

```go
// while 相当（条件のみの for）
func Sum1ToNWhile(n int) int {
    total := 0
    i := 1
    for i <= n {
        total += i
        i++
    }
    return total
}

// for ループ
func Sum1ToNFor(n int) int {
    total := 0
    for i := 1; i <= n; i++ {
        total += i
    }
    return total
}
```

---

## 6. 多重ループ

```go
import (
    "fmt"
    "strings"
)

func MultiplicationTable() string {
    var result strings.Builder
    result.WriteString(strings.Repeat("-", 27) + "\n")
    for i := 1; i <= 9; i++ {
        for j := 1; j <= 9; j++ {
            result.WriteString(fmt.Sprintf("%3d", i*j))
        }
        result.WriteByte('\n')
    }
    result.WriteString(strings.Repeat("-", 27))
    return result.String()
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| while ループ | `while i <= n:` | `for i <= n {` |
| 文字列結合 | `result += "+"` | `strings.Builder` |
| フォーマット | `f"{i*j:3}"` | `fmt.Sprintf("%3d", i*j)` |
| 繰り返し文字列 | `"*" * n` | `strings.Repeat("*", n)` |
