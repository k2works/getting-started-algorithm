module StacksAndQueuesSpec (spec) where

import Test.Hspec
import StacksAndQueues

spec :: Spec
spec = do
  describe "Stack" $ do
    it "push して pop できる" $ do
      s <- newStack
      push s 1
      push s 2
      push s 3
      r1 <- pop s
      r1 `shouldBe` Just 3
      r2 <- pop s
      r2 `shouldBe` Just 2
      r3 <- pop s
      r3 `shouldBe` Just 1
      r4 <- pop s
      r4 `shouldBe` (Nothing :: Maybe Int)

    it "空スタックをチェックできる" $ do
      s <- newStack :: IO (Stack Int)
      isEmpty s `shouldReturn` True
      push s 1
      isEmpty s `shouldReturn` False

    it "peek でスタックトップを確認できる" $ do
      s <- newStack
      push s 42
      peek s `shouldReturn` Just 42
      pop s
      peek s `shouldReturn` (Nothing :: Maybe Int)

  describe "Queue" $ do
    it "enqueue して dequeue できる" $ do
      q <- newQueue
      enqueue q 1
      enqueue q 2
      enqueue q 3
      r1 <- dequeue q
      r1 `shouldBe` Just 1
      r2 <- dequeue q
      r2 `shouldBe` Just 2
      r3 <- dequeue q
      r3 `shouldBe` Just 3
      r4 <- dequeue q
      r4 `shouldBe` (Nothing :: Maybe Int)

    it "空キューをチェックできる" $ do
      q <- newQueue :: IO (Queue Int)
      isQueueEmpty q `shouldReturn` True
      enqueue q 1
      isQueueEmpty q `shouldReturn` False
