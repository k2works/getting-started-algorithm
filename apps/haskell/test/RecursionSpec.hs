module RecursionSpec (spec) where

import Test.Hspec
import Recursion

spec :: Spec
spec = do
  describe "Recursion" $ do
    describe "factorial" $ do
      it "階乗を計算する" $ do
        factorial 0 `shouldBe` 1
        factorial 1 `shouldBe` 1
        factorial 5 `shouldBe` 120
        factorial 10 `shouldBe` 3628800

    describe "gcd'" $ do
      it "最大公約数を計算する" $ do
        gcd' 12 8 `shouldBe` 4
        gcd' 8 12 `shouldBe` 4
        gcd' 7 5 `shouldBe` 1
        gcd' 0 5 `shouldBe` 5

    describe "hanoi" $ do
      it "ハノイの塔の手順を返す" $ do
        let moves = hanoi 3 'A' 'C' 'B'
        length moves `shouldBe` 7
        head moves `shouldBe` ('A', 'C')
        last moves `shouldBe` ('A', 'C')

    describe "eightQueens" $ do
      it "8クイーン問題の解の数を返す" $ do
        length eightQueens `shouldBe` 92
