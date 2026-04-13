module Arrays
  ( maxOfList
  , cardinalNumber
  , primeNumbers
  ) where

-- | リストの最大値を返す（空リストは Nothing）
maxOfList :: Ord a => [a] -> Maybe a
maxOfList []     = Nothing
maxOfList (x:xs) = Just $ foldl max x xs

-- | 各インデックス値の出現頻度を数える
-- cardinalNumber n xs: 0..n-1 の各値が xs に何回現れるか
cardinalNumber :: Int -> [Int] -> [Int]
cardinalNumber n xs = map (\i -> length (filter (== i) xs)) [0..n-1]

-- | エラトステネスの篩で n 以下の素数を返す
primeNumbers :: Int -> [Int]
primeNumbers n = sieve [2..n]
  where
    sieve []     = []
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
