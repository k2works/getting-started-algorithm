# 第 4 章 スタックとキュー（Haskell 版）

## はじめに

前章では探索アルゴリズムを学びました。この章では、データを特定の順序で格納・取り出すための基本的なデータ構造である「スタック」と「キュー」について TDD で実装します。

Haskell は純粋関数型言語ですが、可変状態が必要な場面では `IORef` を使って命令型スタイルに近い実装も可能です。この章では `IORef` による可変状態管理を学びながら、スタックとキューを実装していきます。

### 目次

1. [IORef による可変状態管理](#1-ioref-による可変状態管理)
2. [スタック](#2-スタック)
3. [キュー](#3-キュー)
4. [Python 版との比較](#4-python-版との比較)
5. [スタックとキューの比較](#5-スタックとキューの比較)

---

## 1. IORef による可変状態管理

Haskell は**純粋関数型**言語であり、通常の関数は副作用を持ちません。しかし、スタックやキューのようなデータ構造は「破壊的更新」（値を変更する）を伴うため、可変状態の管理が必要になります。

### IORef とは

`IORef` は Haskell において可変参照（mutable reference）を提供する型です。`IO` モナドの中で値を読み書きできます。

```haskell
import Data.IORef

-- IORef の基本操作
newIORef   :: a -> IO (IORef a)        -- 新しい IORef を作成
readIORef  :: IORef a -> IO a          -- 値を読み取る
writeIORef :: IORef a -> a -> IO ()    -- 値を書き込む
modifyIORef :: IORef a -> (a -> a) -> IO ()  -- 値を変更する
```

### IORef の使用例

```haskell
import Data.IORef

example :: IO ()
example = do
  ref <- newIORef (0 :: Int)    -- 初期値 0 の IORef を作成
  writeIORef ref 42              -- 値を 42 に更新
  val <- readIORef ref           -- 値を読み取る
  print val                      -- 42 を出力

  modifyIORef ref (+1)           -- 値をインクリメント
  val2 <- readIORef ref
  print val2                     -- 43 を出力
```

### IORef と Python の変数の比較

| 操作 | Python | Haskell (IORef) |
|------|--------|-----------------|
| 変数作成 | `x = 0` | `ref <- newIORef 0` |
| 値読み取り | `x` | `readIORef ref` |
| 値書き込み | `x = 42` | `writeIORef ref 42` |
| 値変更 | `x += 1` | `modifyIORef ref (+1)` |

Python では変数への代入は直接できますが、Haskell では `IORef` を介して `IO` アクションとして行います。この違いが「副作用の明示化」という Haskell の設計思想を反映しています。

---

## 2. スタック

スタックは **LIFO（Last In First Out）** — 後から入れたものを最初に取り出す — データ構造です。

皿を積み重ねるのに似ています。新しい皿は常に一番上に置かれ（プッシュ）、皿を取るときも一番上から取ります（ポップ）。

スタックの主な操作は以下の通りです：

- **プッシュ（Push）**: スタックの一番上にデータを追加する
- **ポップ（Pop）**: スタックの一番上からデータを取り出す
- **ピーク（Peek）**: スタックの一番上のデータを参照する（取り出さない）
- **isEmpty**: スタックが空かどうかを確認する

### 設計方針

Haskell での `Stack` 実装は `IORef` でリストを包む方式を採用します。

```
newtype Stack a = Stack (IORef [a])
```

リストの先頭（`:`）でのプッシュ・ポップは O(1) であり、スタックの LIFO 特性に完全に対応します。

### Red — 失敗するテストを書く

```haskell
-- test/StacksAndQueuesSpec.hs
module StacksAndQueuesSpec (spec) where

import Test.Hspec
import StacksAndQueues

spec :: Spec
spec = do
  describe "Stack" $ do
    it "push して pop できる" $ do
      s <- newStack
      push s 1
      push s 2
      push s 3
      r1 <- pop s
      r1 `shouldBe` Just 3   -- LIFO: 最後に入れた 3 が最初に出る
      r2 <- pop s
      r2 `shouldBe` Just 2
      r3 <- pop s
      r3 `shouldBe` Just 1
      r4 <- pop s
      r4 `shouldBe` (Nothing :: Maybe Int)  -- 空スタックは Nothing

    it "空スタックをチェックできる" $ do
      s <- newStack :: IO (Stack Int)
      isEmpty s `shouldReturn` True
      push s 1
      isEmpty s `shouldReturn` False

    it "peek でスタックトップを確認できる" $ do
      s <- newStack
      push s 42
      peek s `shouldReturn` Just 42
      pop s
      peek s `shouldReturn` (Nothing :: Maybe Int)
```

### Green — テストを通す実装

```haskell
-- src/StacksAndQueues.hs
module StacksAndQueues
  ( Stack
  , newStack
  , push
  , pop
  , peek
  , isEmpty
  ) where

import Data.IORef

-- | Stack は IORef でリストを包む
newtype Stack a = Stack (IORef [a])

-- | 新しい空のスタックを作成する
newStack :: IO (Stack a)
newStack = Stack <$> newIORef []

-- | スタックに値をプッシュする（O(1)）
push :: Stack a -> a -> IO ()
push (Stack ref) x = modifyIORef ref (x:)

-- | スタックから値をポップする（O(1)）
-- 空の場合は Nothing を返す
pop :: Stack a -> IO (Maybe a)
pop (Stack ref) = do
  xs <- readIORef ref
  case xs of
    []      -> return Nothing
    (x:xs') -> writeIORef ref xs' >> return (Just x)

-- | スタックトップを参照する（取り出さない）（O(1)）
-- 空の場合は Nothing を返す
peek :: Stack a -> IO (Maybe a)
peek (Stack ref) = do
  xs <- readIORef ref
  case xs of
    []    -> return Nothing
    (x:_) -> return (Just x)

-- | スタックが空かどうかを確認する（O(1)）
isEmpty :: Stack a -> IO Bool
isEmpty (Stack ref) = null <$> readIORef ref
```

### Refactor — リファクタリング

実装はすでにシンプルですが、`pop` の実装をより慣用的な Haskell スタイルで書くこともできます：

```haskell
-- readIORef + atomicModifyIORef を使った原子的な pop
popAtomic :: Stack a -> IO (Maybe a)
popAtomic (Stack ref) = do
  result <- atomicModifyIORef ref $ \xs ->
    case xs of
      []      -> ([], Nothing)
      (x:xs') -> (xs', Just x)
  return result
```

`atomicModifyIORef` を使うと、読み取りと書き込みを原子的に行えるため、並行処理時の安全性が向上します。

### アルゴリズムの考え方

スタック操作の流れ：

```
push(1) → リスト: [1]
push(2) → リスト: [2, 1]
push(3) → リスト: [3, 2, 1]

pop()   → Just 3、リスト: [2, 1]
pop()   → Just 2、リスト: [1]
pop()   → Just 1、リスト: []
pop()   → Nothing（空スタック）
```

Haskell のリストは「先頭への追加」が O(1) のため、スタックとして理想的な構造です。

**主な操作の計算量**:

| 操作 | 関数 | 計算量 | 説明 |
|------|------|--------|------|
| プッシュ | `push` | O(1) | リスト先頭に追加 |
| ポップ | `pop` | O(1) | リスト先頭から取り出す |
| ピーク | `peek` | O(1) | リスト先頭を参照 |
| 空確認 | `isEmpty` | O(1) | null チェック |

### Python 版との実装比較

**Python 版（FixedStack）**:
```python
class FixedStack:
    def __init__(self, capacity: int) -> None:
        self.stk: list[Any] = [None] * capacity
        self.capacity = capacity
        self.ptr = 0  # スタックポインタ

    def push(self, value: Any) -> None:
        if self.is_full():
            raise FixedStack.Full
        self.stk[self.ptr] = value
        self.ptr += 1

    def pop(self) -> Any:
        if self.is_empty():
            raise FixedStack.Empty
        self.ptr -= 1
        return self.stk[self.ptr]
```

**Haskell 版（Stack）**:
```haskell
newtype Stack a = Stack (IORef [a])

push :: Stack a -> a -> IO ()
push (Stack ref) x = modifyIORef ref (x:)

pop :: Stack a -> IO (Maybe a)
pop (Stack ref) = do
  xs <- readIORef ref
  case xs of
    []      -> return Nothing
    (x:xs') -> writeIORef ref xs' >> return (Just x)
```

主な違い：

| 観点 | Python 版 | Haskell 版 |
|------|-----------|------------|
| 容量制限 | 固定長（capacity 指定） | 動的（制限なし） |
| エラー処理 | 例外（Empty/Full） | `Maybe` 型 |
| 状態管理 | インスタンス変数 | `IORef` |
| 型安全性 | 動的型（Any） | 静的型（型パラメータ `a`） |
| null 安全性 | 例外で対処 | `Nothing` で安全に表現 |

---

## 3. キュー

キューは **FIFO（First In First Out）** — 最初に入れたものを最初に取り出す — データ構造です。

銀行の行列をイメージすると分かりやすいです。新しい人は列の最後尾に並び（エンキュー）、サービスを受けるのは列の先頭の人からです（デキュー）。

### 2スタック方式による実装

Haskell のリストはスタックとして使うには最適ですが、キューの末尾への追加は O(n) のコストがかかります。この問題を解決するため、**2スタック方式**を採用します。

```
inbox  （入力用リスト）: enqueue 時に先頭に追加
outbox （出力用リスト）: dequeue 時に先頭から取り出す

outbox が空になったとき、inbox を逆順にして outbox に移動
```

この方式により、**償却 O(1)** で enqueue と dequeue が実現できます。

### 2スタック方式の動作例

```
enqueue(1): inbox=[1],   outbox=[]
enqueue(2): inbox=[2,1], outbox=[]
enqueue(3): inbox=[3,2,1], outbox=[]

dequeue():
  outbox が空 → inbox を逆順して outbox=[1,2,3], inbox=[]
  outbox 先頭を取り出す → Just 1, outbox=[2,3]

dequeue(): outbox=[2,3] から Just 2 を取り出す, outbox=[3]
dequeue(): outbox=[3]   から Just 3 を取り出す, outbox=[]

dequeue():
  outbox が空、inbox も空 → Nothing
```

### Red — 失敗するテストを書く

```haskell
-- test/StacksAndQueuesSpec.hs
describe "Queue" $ do
  it "enqueue して dequeue できる" $ do
    q <- newQueue
    enqueue q 1
    enqueue q 2
    enqueue q 3
    r1 <- dequeue q
    r1 `shouldBe` Just 1   -- FIFO: 最初に入れた 1 が最初に出る
    r2 <- dequeue q
    r2 `shouldBe` Just 2
    r3 <- dequeue q
    r3 `shouldBe` Just 3
    r4 <- dequeue q
    r4 `shouldBe` (Nothing :: Maybe Int)  -- 空キューは Nothing

  it "空キューをチェックできる" $ do
    q <- newQueue :: IO (Queue Int)
    isQueueEmpty q `shouldReturn` True
    enqueue q 1
    isQueueEmpty q `shouldReturn` False
```

### Green — テストを通す実装

```haskell
-- src/StacksAndQueues.hs
-- | Queue は inbox（エンキュー用）と outbox（デキュー用）の2つの IORef リスト
data Queue a = Queue (IORef [a]) (IORef [a])

-- | 新しい空のキューを作成する
newQueue :: IO (Queue a)
newQueue = Queue <$> newIORef [] <*> newIORef []

-- | キューの末尾に値を追加する（償却 O(1)）
enqueue :: Queue a -> a -> IO ()
enqueue (Queue inbox _) x = modifyIORef inbox (x:)

-- | キューの先頭から値を取り出す（償却 O(1)）
-- 空の場合は Nothing を返す
dequeue :: Queue a -> IO (Maybe a)
dequeue (Queue inbox outbox) = do
  out <- readIORef outbox
  case out of
    (x:xs) -> writeIORef outbox xs >> return (Just x)
    [] -> do
      inp <- readIORef inbox
      case reverse inp of
        []     -> return Nothing
        (x:xs) -> do
          writeIORef inbox []
          writeIORef outbox xs
          return (Just x)

-- | キューが空かどうかを確認する
isQueueEmpty :: Queue a -> IO Bool
isQueueEmpty (Queue inbox outbox) = do
  inp <- readIORef inbox
  out <- readIORef outbox
  return (null inp && null out)
```

### dequeue の動作解説

```haskell
dequeue (Queue inbox outbox) = do
  out <- readIORef outbox
  case out of
    -- outbox に要素がある場合: 先頭を取り出す
    (x:xs) -> writeIORef outbox xs >> return (Just x)
    -- outbox が空の場合: inbox を逆順にして outbox に移動
    [] -> do
      inp <- readIORef inbox
      case reverse inp of
        []     -> return Nothing       -- 両方空 → Nothing
        (x:xs) -> do
          writeIORef inbox []          -- inbox をクリア
          writeIORef outbox xs         -- 残りを outbox に設定
          return (Just x)             -- 先頭を返す
```

### 償却計算量の説明

各要素は：
1. `enqueue` で inbox に追加される（1回）
2. `reverse` 時に outbox に移動される（1回）
3. `dequeue` で outbox から取り出される（1回）

合計3回の操作しか行われないため、n 回の操作の平均コストは O(1) になります（**償却 O(1)**）。

### Python 版との実装比較

**Python 版（FixedQueue — リングバッファ）**:
```python
class FixedQueue:
    def __init__(self, capacity: int) -> None:
        self.que = [None] * capacity
        self.front = 0   # 先頭インデックス
        self.rear = 0    # 末尾インデックス
        self.num = 0     # 要素数

    def enque(self, value: Any) -> None:
        if self.is_full():
            raise FixedQueue.Full
        self.que[self.rear] = value
        self.rear = (self.rear + 1) % self.capacity
        self.num += 1

    def deque(self) -> Any:
        if self.is_empty():
            raise FixedQueue.Empty
        value = self.que[self.front]
        self.front = (self.front + 1) % self.capacity
        self.num -= 1
        return value
```

**Haskell 版（Queue — 2スタック方式）**:
```haskell
data Queue a = Queue (IORef [a]) (IORef [a])

enqueue :: Queue a -> a -> IO ()
enqueue (Queue inbox _) x = modifyIORef inbox (x:)

dequeue :: Queue a -> IO (Maybe a)
dequeue (Queue inbox outbox) = do
  out <- readIORef outbox
  case out of
    (x:xs) -> writeIORef outbox xs >> return (Just x)
    [] -> do
      inp <- readIORef inbox
      case reverse inp of
        []     -> return Nothing
        (x:xs) -> do
          writeIORef inbox []
          writeIORef outbox xs
          return (Just x)
```

主な違い：

| 観点 | Python 版（リングバッファ） | Haskell 版（2スタック） |
|------|--------------------------|------------------------|
| 実装方式 | 配列 + front/rear インデックス | 2つの IORef リスト |
| 容量 | 固定長 | 動的 |
| エラー処理 | 例外（Empty/Full） | `Maybe` 型 |
| メモリ効率 | O(capacity) 固定 | O(n) 動的 |
| 計算量（enqueue） | O(1) | O(1) 償却 |
| 計算量（dequeue） | O(1) | O(1) 償却 |

---

## 4. Python 版との比較

### 設計思想の違い

| 観点 | Python | Haskell |
|------|--------|---------|
| 状態管理 | クラスのフィールド | `IORef` |
| エラー処理 | 例外（raise） | `Maybe` 型 |
| 型システム | 動的型付け | 静的型付け（型推論） |
| 副作用 | 暗黙的 | `IO` モナドで明示 |
| ポリモーフィズム | 鴨の型付け | 型クラスとパラメトリック多相 |

### エラー処理の比較

Python 版では例外を使います：

```python
def pop(self) -> Any:
    if self.is_empty():
        raise FixedStack.Empty  # 例外を投げる
    self.ptr -= 1
    return self.stk[self.ptr]

# 使用側
try:
    value = stack.pop()
except FixedStack.Empty:
    print("スタックが空です")
```

Haskell 版では `Maybe` 型で安全に表現します：

```haskell
pop :: Stack a -> IO (Maybe a)
pop (Stack ref) = do
  xs <- readIORef ref
  case xs of
    []      -> return Nothing  -- 空の場合は Nothing
    (x:xs') -> writeIORef ref xs' >> return (Just x)

-- 使用側
result <- pop stack
case result of
  Nothing -> putStrLn "スタックが空です"
  Just x  -> putStrLn $ "取り出した値: " ++ show x
```

`Maybe` 型を使うことで：
- コンパイル時に「空の場合」の処理が強制される
- 実行時例外が発生しない
- 型シグネチャを見るだけでエラー可能性が分かる

### IO モナドの役割

Haskell において `IO` モナドは**副作用の境界**を定義します：

```haskell
-- IO を返す関数は副作用を持つことを型で表現
newStack :: IO (Stack a)
push     :: Stack a -> a -> IO ()
pop      :: Stack a -> IO (Maybe a)

-- do 記法で順序付き副作用を記述
example :: IO ()
example = do
  s <- newStack        -- 新しいスタックを作成
  push s 1             -- 1 をプッシュ
  push s 2             -- 2 をプッシュ
  x <- pop s           -- ポップ
  print x              -- Just 2 を出力
```

Python ではこのような副作用の「見える化」は型システムでは行われません。

---

## 5. スタックとキューの比較

| 項目 | スタック | キュー |
|------|---------|--------|
| 取り出し順序 | LIFO（後入れ先出し） | FIFO（先入れ先出し） |
| 追加操作 | `push` | `enqueue` |
| 取り出し操作 | `pop` | `dequeue` |
| 主な用途 | 関数呼び出し管理、DFS | タスクキュー、BFS |
| Haskell での実装 | `IORef [a]` | `IORef [a]` × 2（2スタック） |
| 計算量（追加/取り出し） | O(1) | O(1) 償却 |
| エラー処理 | `Maybe` 型 | `Maybe` 型 |

---

## テスト実行結果

```bash
$ cd apps/haskell && cabal test

Stack
  push して pop できる             OK
  空スタックをチェックできる         OK
  peek でスタックトップを確認できる  OK
Queue
  enqueue して dequeue できる      OK
  空キューをチェックできる           OK

Finished in 0.0012 seconds
5 examples, 0 failures
```

---

## まとめ

この章では、Haskell における IORef を使ったスタックとキューの実装を学びました：

1. **IORef** — Haskell で可変状態を扱うための仕組み。`IO` モナドの中で値の読み書きができる。

2. **Stack** — `newtype Stack a = Stack (IORef [a])` として実装。リストの先頭操作を利用した O(1) のプッシュ・ポップ。

3. **Queue** — `data Queue a = Queue (IORef [a]) (IORef [a])` として実装。2スタック方式により償却 O(1) のエンキュー・デキューを実現。

4. **Maybe 型** — Python の例外に相当するエラー処理。`Nothing` と `Just x` で安全に空の場合を表現。

5. **IO モナド** — 副作用を型システムで明示的に扱う Haskell の仕組み。

Python 版と比べると、Haskell 版は型安全性が高く、エラー処理が明示的です。`IORef` を使うことで命令型スタイルに近い実装も可能ですが、すべての副作用が `IO` 型で表現されるため、どこで状態が変化するかが明確になります。

次の章では、再帰アルゴリズムについて学んでいきましょう。

## 参考文献

- 『プログラミング Haskell（第 2 版）』 — Graham Hutton
- 『すごい Haskell たのしく学ぼう！』 — Miran Lipovača
- 『テスト駆動開発』 — Kent Beck
