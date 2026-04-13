module StringsSpec (spec) where

import Test.Hspec
import Strings

spec :: Spec
spec = do
  describe "Strings" $ do
    let text    = "mississippi"
    let pattern = "issi"

    describe "bruteForceSearch" $ do
      it "総当たり法で部分文字列を探す" $ do
        bruteForceSearch text pattern `shouldBe` Just 1
        bruteForceSearch text "xxx" `shouldBe` Nothing
        bruteForceSearch "" "a" `shouldBe` Nothing
        bruteForceSearch "a" "" `shouldBe` Just 0

    describe "kmpSearch" $ do
      it "KMP 法で部分文字列を探す" $ do
        kmpSearch text pattern `shouldBe` Just 1
        kmpSearch text "xxx" `shouldBe` Nothing
        kmpSearch "aabaabaab" "aab" `shouldBe` Just 0

    describe "bmSearch" $ do
      it "BM 法で部分文字列を探す" $ do
        bmSearch text pattern `shouldBe` Just 1
        bmSearch text "xxx" `shouldBe` Nothing

    describe "charCount" $ do
      it "各文字の出現頻度をカウントする" $ do
        charCount "hello" 'l' `shouldBe` 2
        charCount "hello" 'z' `shouldBe` 0
        charCount "" 'a' `shouldBe` 0

    describe "reverseString" $ do
      it "文字列を逆順にする" $ do
        reverseString "hello" `shouldBe` "olleh"
        reverseString "" `shouldBe` ""
        reverseString "a" `shouldBe` "a"

    describe "isPalindrome" $ do
      it "回文かどうかを判定する" $ do
        isPalindrome "racecar" `shouldBe` True
        isPalindrome "hello" `shouldBe` False
        isPalindrome "" `shouldBe` True
        isPalindrome "a" `shouldBe` True
