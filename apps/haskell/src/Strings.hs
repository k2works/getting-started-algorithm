module Strings
  ( bruteForceSearch
  , kmpSearch
  , bmSearch
  , charCount
  , reverseString
  , isPalindrome
  ) where

import Data.List (isPrefixOf)
import qualified Data.Map.Strict as Map

-- | 総当たり法（Brute-Force）による部分文字列探索
bruteForceSearch :: String -> String -> Maybe Int
bruteForceSearch _ [] = Just 0
bruteForceSearch text pat = go text 0
  where
    go [] _ = Nothing
    go ts i
      | pat `isPrefixOf` ts = Just i
      | otherwise            = go (tail ts) (i + 1)

-- | KMP 法による部分文字列探索
kmpSearch :: String -> String -> Maybe Int
kmpSearch _ [] = Just 0
kmpSearch text pat = go 0 0
  where
    m    = length pat
    n    = length text
    tarr = text
    parr = pat
    failure = buildFailure pat
    go i j
      | i >= n         = Nothing
      | parr !! j == tarr !! i =
          if j + 1 == m
          then Just (i - j)
          else go (i + 1) (j + 1)
      | j == 0         = go (i + 1) 0
      | otherwise       = go i (failure !! (j - 1))
    buildFailure p =
      let m' = length p
          go' 1 acc = acc
          go' k acc =
            let prev = acc !! (k - 2)
                fill f
                  | f > 0 && p !! f /= p !! (k - 1) = fill (acc !! (f - 1))
                  | otherwise = f
                f' = fill prev
                v  = if p !! f' == p !! (k - 1) then f' + 1 else 0
            in go' (k - 1) (take (k - 1) acc ++ [v] ++ drop k acc)
      in go' m' (replicate m' 0)

-- | BM 法による部分文字列探索
bmSearch :: String -> String -> Maybe Int
bmSearch _ [] = Just 0
bmSearch text pat = go 0
  where
    m    = length pat
    n    = length text
    skip = Map.fromListWith min
             [(c, m - 1 - i) | (i, c) <- zip [0..] pat]
    getSkip c = Map.findWithDefault m c skip
    go i
      | i + m > n = Nothing
      | otherwise =
          let j = m - 1
              check k
                | k < 0     = Just i
                | text !! (i + k) == pat !! k = check (k - 1)
                | otherwise =
                    let s = max 1 (getSkip (text !! (i + k)) - (m - 1 - k))
                    in go (i + s)
          in check j

-- | 特定文字の出現回数をカウント
charCount :: String -> Char -> Int
charCount s c = length (filter (== c) s)

-- | 文字列を逆順にする
reverseString :: String -> String
reverseString = reverse

-- | 回文判定
isPalindrome :: String -> Bool
isPalindrome s = s == reverse s
