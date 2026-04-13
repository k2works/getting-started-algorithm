module SortAlgorithms
  ( bubbleSort
  , selectionSort
  , insertionSort
  , shellSort
  , quickSort
  , mergeSort
  , heapSort
  , countingSort
  ) where

import Data.List (partition)
import Data.Array (listArray, (!), (//), bounds, elems)

-- | バブルソート
bubbleSort :: Ord a => [a] -> [a]
bubbleSort [] = []
bubbleSort xs = iterate bubble xs !! (length xs - 1)
  where
    bubble []       = []
    bubble [y]      = [y]
    bubble (y:z:ys)
      | y > z     = z : bubble (y:ys)
      | otherwise = y : bubble (z:ys)

-- | 選択ソート
selectionSort :: Ord a => [a] -> [a]
selectionSort [] = []
selectionSort xs =
  let m  = minimum xs
      rest = deleteFirst m xs
  in m : selectionSort rest
  where
    deleteFirst _ [] = []
    deleteFirst v (y:ys)
      | v == y    = ys
      | otherwise = y : deleteFirst v ys

-- | 挿入ソート
insertionSort :: Ord a => [a] -> [a]
insertionSort = foldr insert' []
  where
    insert' x [] = [x]
    insert' x (y:ys)
      | x <= y    = x : y : ys
      | otherwise = y : insert' x ys

-- | シェルソート（配列ベースで正確に実装）
shellSort :: Ord a => [a] -> [a]
shellSort [] = []
shellSort xs = elems $ foldl passGap arr gaps
  where
    n    = length xs
    arr  = listArray (0, n - 1) xs
    gaps = takeWhile (> 0) $ iterate (`div` 2) (n `div` 2)
    passGap a h = foldl (insertAt h) a [h .. n - 1]
    insertAt h a i =
      let val = a ! i
          go j acc
            | j >= h && acc ! (j - h) > val =
                go (j - h) (acc // [(j, acc ! (j - h))])
            | otherwise = acc // [(j, val)]
      in go i a

-- | クイックソート
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  let (smaller, larger) = partition (<= x) xs
  in quickSort smaller ++ [x] ++ quickSort larger

-- | マージソート
mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort xs =
  let (l, r) = splitAt (length xs `div` 2) xs
  in merge (mergeSort l) (mergeSort r)
  where
    merge [] ys = ys
    merge xs [] = xs
    merge (a:as) (b:bs)
      | a <= b    = a : merge as (b:bs)
      | otherwise = b : merge (a:as) bs

-- | ヒープソート（配列ベース）
heapSort :: Ord a => [a] -> [a]
heapSort [] = []
heapSort xs = elems $ extractAll (buildMaxHeap arr) n
  where
    n    = length xs
    arr  = listArray (0, n - 1) xs
    swap i j a = a // [(i, a ! j), (j, a ! i)]
    heapify a i sz =
      let l = 2 * i + 1
          r = 2 * i + 2
          cands = filter (< sz) [l, r]
          largest = foldl (\m j -> if a ! j > a ! m then j else m) i cands
      in if largest /= i
         then heapify (swap i largest a) largest sz
         else a
    buildMaxHeap a = foldl (\acc i -> heapify acc i n) a [n `div` 2 - 1, n `div` 2 - 2 .. 0]
    extractAll a 0 = a
    extractAll a sz =
      let a' = swap 0 (sz - 1) a
      in extractAll (heapify a' 0 (sz - 1)) (sz - 1)

-- | 度数ソート（0 以上の整数のみ）
countingSort :: Int -> [Int] -> [Int]
countingSort k xs =
  let count = map (\i -> length (filter (== i) xs)) [0..k-1]
  in concatMap (\(i, c) -> replicate c i) (zip [0..] count)
