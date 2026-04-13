module SearchAlgorithmsSpec (spec) where

import Test.Hspec
import SearchAlgorithms

spec :: Spec
spec = do
  describe "SearchAlgorithms" $ do
    let xs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    describe "linearSearch" $ do
      it "線形探索で要素のインデックスを返す" $ do
        linearSearch xs 3 `shouldBe` Just 2
        linearSearch xs 10 `shouldBe` Just 9
        linearSearch xs 11 `shouldBe` Nothing
        linearSearch ([] :: [Int]) 1 `shouldBe` Nothing

    describe "binarySearch" $ do
      it "二分探索でソート済みリストの要素インデックスを返す" $ do
        binarySearch xs 3 `shouldBe` Just 2
        binarySearch xs 10 `shouldBe` Just 9
        binarySearch xs 1 `shouldBe` Just 0
        binarySearch xs 11 `shouldBe` Nothing
        binarySearch ([] :: [Int]) 1 `shouldBe` Nothing

    describe "hashSearch" $ do
      it "ハッシュ探索で要素の存在を確認する" $ do
        hashSearch xs 3 `shouldBe` True
        hashSearch xs 11 `shouldBe` False
        hashSearch ([] :: [Int]) 1 `shouldBe` False
