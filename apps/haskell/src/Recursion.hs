module Recursion
  ( factorial
  , gcd'
  , hanoi
  , eightQueens
  ) where

-- | 階乗（末尾再帰）
factorial :: Integer -> Integer
factorial n = go n 1
  where
    go 0 acc = acc
    go k acc = go (k - 1) (k * acc)

-- | ユークリッドの互除法による最大公約数
gcd' :: Int -> Int -> Int
gcd' a 0 = a
gcd' a b = gcd' b (a `mod` b)

-- | ハノイの塔：(from, to) のペアリストを返す
hanoi :: Int -> a -> a -> a -> [(a, a)]
hanoi 0 _ _ _ = []
hanoi n from to via =
  hanoi (n - 1) from via to
  ++ [(from, to)]
  ++ hanoi (n - 1) via to from

-- | 8クイーン問題：全ての解を返す（各解はクイーンの列インデックスリスト）
eightQueens :: [[Int]]
eightQueens = queens 8
  where
    queens 0 = [[]]
    queens k = [ q : qs
               | qs <- queens (k - 1)
               , q  <- [0..7]
               , safe q qs
               ]
    safe q qs = and [ q /= q'
                    && abs (q - q') /= d
                    | (q', d) <- zip qs [1..]
                    ]
