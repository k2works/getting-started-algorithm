# 第 4 章 スタックとキュー

## はじめに

この章では固定長スタックと固定長キュー（リングバッファ）をジェネリクスを使って TDD で実装します。

---

## 1. 固定長スタック

LIFO（Last In, First Out）のデータ構造です。

```java
public class FixedStack<T> {
    private final Object[] stk;
    private int ptr;

    public void push(T value) {
        if (isFull()) throw new FullException();
        stk[ptr++] = value;
    }

    @SuppressWarnings("unchecked")
    public T pop() {
        if (isEmpty()) throw new EmptyException();
        return (T) stk[--ptr];
    }
}
```

---

## 2. 固定長キュー（リングバッファ）

FIFO（First In, First Out）のデータ構造です。配列の末尾に達したら先頭に戻るリングバッファ方式で実装します。

```java
public void enque(T value) {
    if (isFull()) throw new FullException();
    que[rear] = value;
    rear++;
    num++;
    if (rear == capacity) rear = 0; // 折り返し
}
```

---

## Python との比較

| 概念 | Python | Java |
|------|--------|------|
| ジェネリクス | `list[Any]` | `FixedStack<T>` |
| 例外 | `raise FixedStack.Full` | `throw new FullException()` |
| 型キャスト | 不要 | `@SuppressWarnings("unchecked")` + キャスト |

---

## テスト実行結果

```
StackQueueTest > FixedStackTest > pushしてpop() PASSED
StackQueueTest > FixedStackTest > 複数pushしてLIFO順にpop() PASSED
StackQueueTest > FixedQueueTest > enqueしてdeque() PASSED
StackQueueTest > FixedQueueTest > リングバッファの折り返し() PASSED
```
