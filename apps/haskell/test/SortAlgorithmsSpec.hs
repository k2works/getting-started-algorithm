module SortAlgorithmsSpec (spec) where

import Test.Hspec
import SortAlgorithms

spec :: Spec
spec = do
  describe "SortAlgorithms" $ do
    let unsorted = [5, 3, 8, 1, 9, 2, 7, 4, 6] :: [Int]
    let sorted   = [1, 2, 3, 4, 5, 6, 7, 8, 9] :: [Int]

    describe "bubbleSort" $ do
      it "バブルソートでソートする" $ do
        bubbleSort unsorted `shouldBe` sorted
        bubbleSort ([] :: [Int]) `shouldBe` []
        bubbleSort [1] `shouldBe` [1]

    describe "selectionSort" $ do
      it "選択ソートでソートする" $ do
        selectionSort unsorted `shouldBe` sorted

    describe "insertionSort" $ do
      it "挿入ソートでソートする" $ do
        insertionSort unsorted `shouldBe` sorted

    describe "shellSort" $ do
      it "シェルソートでソートする" $ do
        shellSort unsorted `shouldBe` sorted

    describe "quickSort" $ do
      it "クイックソートでソートする" $ do
        quickSort unsorted `shouldBe` sorted
        quickSort ([] :: [Int]) `shouldBe` []

    describe "mergeSort" $ do
      it "マージソートでソートする" $ do
        mergeSort unsorted `shouldBe` sorted
        mergeSort ([] :: [Int]) `shouldBe` []

    describe "heapSort" $ do
      it "ヒープソートでソートする" $ do
        heapSort unsorted `shouldBe` sorted

    describe "countingSort" $ do
      it "度数ソートでソートする" $ do
        countingSort 10 [5, 3, 8, 1, 9, 2, 7, 4, 6] `shouldBe` sorted
        countingSort 5 [4, 2, 3, 1, 0] `shouldBe` [0, 1, 2, 3, 4]
