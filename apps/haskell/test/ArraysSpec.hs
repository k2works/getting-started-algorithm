module ArraysSpec (spec) where

import Test.Hspec
import Arrays

spec :: Spec
spec = do
  describe "Arrays" $ do
    describe "maxOfList" $ do
      it "リストの最大値を返す" $ do
        maxOfList [3, 2, 1, 4, 0] `shouldBe` Just 4
        maxOfList [1] `shouldBe` Just 1
        maxOfList ([] :: [Int]) `shouldBe` Nothing

    describe "cardinalNumber" $ do
      it "要素の頻度を数える" $ do
        cardinalNumber 10 [1, 3, 2, 3, 1, 5] `shouldBe` [0, 2, 1, 2, 0, 1, 0, 0, 0, 0]
        cardinalNumber 5 [] `shouldBe` [0, 0, 0, 0, 0]

    describe "primeNumbers" $ do
      it "n以下の素数リストを返す" $ do
        primeNumbers 20 `shouldBe` [2, 3, 5, 7, 11, 13, 17, 19]
        primeNumbers 10 `shouldBe` [2, 3, 5, 7]
        primeNumbers 2 `shouldBe` [2]
        primeNumbers 1 `shouldBe` []
