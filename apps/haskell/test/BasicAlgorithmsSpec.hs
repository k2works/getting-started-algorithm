module BasicAlgorithmsSpec (spec) where

import Test.Hspec
import BasicAlgorithms

spec :: Spec
spec = do
  describe "BasicAlgorithms" $ do
    describe "max3" $ do
      it "3つの数値の最大値を返す" $ do
        max3 3 2 1 `shouldBe` 3
        max3 1 3 2 `shouldBe` 3
        max3 1 2 3 `shouldBe` 3
        max3 2 2 2 `shouldBe` 2

    describe "mid3" $ do
      it "3つの数値の中央値を返す" $ do
        mid3 3 2 1 `shouldBe` 2
        mid3 1 3 2 `shouldBe` 2
        mid3 1 2 3 `shouldBe` 2
        mid3 2 2 2 `shouldBe` 2
