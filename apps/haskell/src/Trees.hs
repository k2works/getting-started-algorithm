module Trees
  ( BST
  , empty
  , insert
  , member
  , inOrder
  , preOrder
  , postOrder
  , findMin
  , findMax
  , delete
  ) where

-- | 二分探索木の代数的データ型
data BST a = Empty | Node a (BST a) (BST a)
  deriving (Show, Eq)

-- | 空の BST
empty :: BST a
empty = Empty

-- | 要素を挿入する
insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
  | x < y    = Node y (insert x left) right
  | x > y    = Node y left (insert x right)
  | otherwise = Node y left right

-- | 要素が含まれるか
member :: Ord a => BST a -> a -> Bool
member Empty _ = False
member (Node y left right) x
  | x == y   = True
  | x < y    = member left x
  | otherwise = member right x

-- | 中順走査（昇順）
inOrder :: BST a -> [a]
inOrder Empty            = []
inOrder (Node x left right) = inOrder left ++ [x] ++ inOrder right

-- | 前順走査
preOrder :: BST a -> [a]
preOrder Empty              = []
preOrder (Node x left right) = [x] ++ preOrder left ++ preOrder right

-- | 後順走査
postOrder :: BST a -> [a]
postOrder Empty              = []
postOrder (Node x left right) = postOrder left ++ postOrder right ++ [x]

-- | 最小値を返す
findMin :: BST a -> Maybe a
findMin Empty          = Nothing
findMin (Node x Empty _) = Just x
findMin (Node _ left _)  = findMin left

-- | 最大値を返す
findMax :: BST a -> Maybe a
findMax Empty           = Nothing
findMax (Node x _ Empty) = Just x
findMax (Node _ _ right) = findMax right

-- | 要素を削除する
delete :: Ord a => BST a -> a -> BST a
delete Empty _ = Empty
delete (Node y left right) x
  | x < y    = Node y (delete left x) right
  | x > y    = Node y left (delete right x)
  | otherwise = case (left, right) of
      (Empty, _) -> right
      (_, Empty) -> left
      _          -> let Just minVal = findMin right
                    in Node minVal left (delete right minVal)
