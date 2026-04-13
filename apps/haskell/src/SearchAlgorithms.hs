module SearchAlgorithms
  ( linearSearch
  , binarySearch
  , hashSearch
  ) where

import qualified Data.Set as Set

-- | 線形探索：リストを先頭から順に走査して対象を探す
linearSearch :: Eq a => [a] -> a -> Maybe Int
linearSearch xs target = go xs 0
  where
    go [] _ = Nothing
    go (y:ys) i
      | y == target = Just i
      | otherwise   = go ys (i + 1)

-- | 二分探索：ソート済みリストで対象を探す
binarySearch :: Ord a => [a] -> a -> Maybe Int
binarySearch [] _ = Nothing
binarySearch xs target = go 0 (length xs - 1)
  where
    arr = xs
    go lo hi
      | lo > hi = Nothing
      | arr !! mid == target = Just mid
      | arr !! mid < target  = go (mid + 1) hi
      | otherwise             = go lo (mid - 1)
      where mid = (lo + hi) `div` 2

-- | ハッシュ探索：Set を使って O(log n) で存在を確認
hashSearch :: Ord a => [a] -> a -> Bool
hashSearch xs target = Set.member target (Set.fromList xs)
