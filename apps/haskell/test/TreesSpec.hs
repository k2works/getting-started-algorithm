module TreesSpec (spec) where

import Test.Hspec
import Trees

spec :: Spec
spec = do
  describe "BinarySearchTree" $ do
    let bst = foldr insert empty [5, 3, 7, 1, 4, 6, 8]

    describe "insert / member" $ do
      it "要素を挿入して探索できる" $ do
        member bst 5 `shouldBe` True
        member bst 3 `shouldBe` True
        member bst 9 `shouldBe` False
        member empty 1 `shouldBe` False

    describe "inOrder" $ do
      it "中順走査でソート済みリストを返す" $ do
        inOrder bst `shouldBe` [1, 3, 4, 5, 6, 7, 8]

    describe "preOrder" $ do
      it "前順走査を返す" $ do
        preOrder bst `shouldBe` [8, 6, 4, 1, 3, 5, 7]

    describe "postOrder" $ do
      it "後順走査を返す" $ do
        postOrder bst `shouldBe` [3, 1, 5, 4, 7, 6, 8]

    describe "findMin / findMax" $ do
      it "最小値・最大値を返す" $ do
        findMin bst `shouldBe` Just 1
        findMax bst `shouldBe` Just 8
        findMin (empty :: BST Int) `shouldBe` Nothing
        findMax (empty :: BST Int) `shouldBe` Nothing

    describe "delete" $ do
      it "要素を削除できる" $ do
        let bst2 = delete bst 3
        member bst2 3 `shouldBe` False
        inOrder bst2 `shouldBe` [1, 4, 5, 6, 7, 8]
        let bst3 = delete bst 5
        member bst3 5 `shouldBe` False
        inOrder bst3 `shouldBe` [1, 3, 4, 6, 7, 8]
