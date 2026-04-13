module StacksAndQueues
  ( Stack
  , newStack
  , push
  , pop
  , peek
  , isEmpty
  , Queue
  , newQueue
  , enqueue
  , dequeue
  , isQueueEmpty
  ) where

import Data.IORef

-- ---------------------------------------------------------------------------
-- Stack（IORef ベース）
-- ---------------------------------------------------------------------------

newtype Stack a = Stack (IORef [a])

newStack :: IO (Stack a)
newStack = Stack <$> newIORef []

push :: Stack a -> a -> IO ()
push (Stack ref) x = modifyIORef ref (x:)

pop :: Stack a -> IO (Maybe a)
pop (Stack ref) = do
  xs <- readIORef ref
  case xs of
    []     -> return Nothing
    (x:xs') -> writeIORef ref xs' >> return (Just x)

peek :: Stack a -> IO (Maybe a)
peek (Stack ref) = do
  xs <- readIORef ref
  case xs of
    []    -> return Nothing
    (x:_) -> return (Just x)

isEmpty :: Stack a -> IO Bool
isEmpty (Stack ref) = null <$> readIORef ref

-- ---------------------------------------------------------------------------
-- Queue（2スタック方式: 償却 O(1)）
-- ---------------------------------------------------------------------------

data Queue a = Queue (IORef [a]) (IORef [a])

newQueue :: IO (Queue a)
newQueue = Queue <$> newIORef [] <*> newIORef []

enqueue :: Queue a -> a -> IO ()
enqueue (Queue inbox _) x = modifyIORef inbox (x:)

dequeue :: Queue a -> IO (Maybe a)
dequeue (Queue inbox outbox) = do
  out <- readIORef outbox
  case out of
    (x:xs) -> writeIORef outbox xs >> return (Just x)
    [] -> do
      inp <- readIORef inbox
      case reverse inp of
        []     -> return Nothing
        (x:xs) -> do
          writeIORef inbox []
          writeIORef outbox xs
          return (Just x)

isQueueEmpty :: Queue a -> IO Bool
isQueueEmpty (Queue inbox outbox) = do
  inp <- readIORef inbox
  out <- readIORef outbox
  return (null inp && null out)
