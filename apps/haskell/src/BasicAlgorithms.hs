module BasicAlgorithms
  ( max3
  , mid3
  ) where

-- | 3つの値の最大値を返す
max3 :: Ord a => a -> a -> a -> a
max3 a b c = max a (max b c)

-- | 3つの値の中央値を返す
mid3 :: Ord a => a -> a -> a -> a
mid3 a b c
  | (a >= b && a <= c) || (a >= c && a <= b) = a
  | (b >= a && b <= c) || (b >= c && b <= a) = b
  | otherwise = c
