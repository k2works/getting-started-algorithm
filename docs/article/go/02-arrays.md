# 第 2 章 配列

## はじめに

Go では配列（固定長）とスライス（可変長）の 2 種類のシーケンス型があります。実務では主にスライスを使います。

---

## 1. 配列とは

Go のスライスは Python のリストに相当します。

```go
a := []int{172, 153, 192, 140, 165}
```

---

## 2. 配列の基本操作

### 最大値

```go
func MaxOf(a []int) int {
    maximum := a[0]
    for i := 1; i < len(a); i++ {
        if a[i] > maximum {
            maximum = a[i]
        }
    }
    return maximum
}
```

### 反転

Go のスライスは参照型なので、関数内で変更が反映されます。

```go
func ReverseArray(a []int) {
    n := len(a)
    for i := 0; i < n/2; i++ {
        a[i], a[n-i-1] = a[n-i-1], a[i]
    }
}
```

---

## 3. 基数変換

```go
func CardConv(x, r int) string {
    dchar := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    digits := []byte{}
    for x > 0 {
        digits = append(digits, dchar[x%r])
        x /= r
    }
    // 反転
    for i, j := 0, len(digits)-1; i < j; i, j = i+1, j-1 {
        digits[i], digits[j] = digits[j], digits[i]
    }
    return string(digits)
}
```

---

## 4. 素数の列挙

```go
func Prime1(x int) int {
    counter := 0
    for n := 2; n <= x; n++ {
        for i := 2; i < n; i++ {
            counter++
            if n%i == 0 {
                break
            }
        }
    }
    return counter
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| スライス | `a = [1, 2, 3]` | `a := []int{1, 2, 3}` |
| 長さ | `len(a)` | `len(a)` |
| 追加 | `a.append(x)` | `a = append(a, x)` |
| 多重代入 | `a[i], a[j] = a[j], a[i]` | `a[i], a[j] = a[j], a[i]` |
| 整数除算 | `x // r` | `x / r`（整数同士） |
