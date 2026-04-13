module LinkedListsSpec (spec) where

import Test.Hspec
import LinkedLists

spec :: Spec
spec = do
  describe "LinkedList" $ do
    it "追加・削除・検索ができる" $ do
      ll <- newLinkedList
      appendLL ll 1
      appendLL ll 2
      appendLL ll 3
      toListLL ll `shouldReturn` [1, 2, 3]
      searchLL ll 2 `shouldReturn` True
      searchLL ll 4 `shouldReturn` False
      deleteLL ll 2
      toListLL ll `shouldReturn` [1, 3]

    it "先頭に追加できる" $ do
      ll <- newLinkedList
      prependLL ll 3
      prependLL ll 2
      prependLL ll 1
      toListLL ll `shouldReturn` [1, 2, 3]

  describe "DoublyLinkedList" $ do
    it "追加・削除・双方向走査ができる" $ do
      dl <- newDoublyLinkedList
      appendDL dl 1
      appendDL dl 2
      appendDL dl 3
      toListDL dl `shouldReturn` [1, 2, 3]
      toRevListDL dl `shouldReturn` [3, 2, 1]
      deleteDL dl 2
      toListDL dl `shouldReturn` [1, 3]
