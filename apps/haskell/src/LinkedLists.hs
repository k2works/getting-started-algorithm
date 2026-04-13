module LinkedLists
  ( LinkedList
  , newLinkedList
  , appendLL
  , prependLL
  , deleteLL
  , searchLL
  , toListLL
  , DoublyLinkedList
  , newDoublyLinkedList
  , appendDL
  , deleteDL
  , toListDL
  , toRevListDL
  ) where

import Data.IORef

-- ---------------------------------------------------------------------------
-- Singly Linked List（IORef + immutable list）
-- ---------------------------------------------------------------------------

newtype LinkedList a = LinkedList (IORef [a])

newLinkedList :: IO (LinkedList a)
newLinkedList = LinkedList <$> newIORef []

appendLL :: LinkedList a -> a -> IO ()
appendLL (LinkedList ref) x = modifyIORef ref (++ [x])

prependLL :: LinkedList a -> a -> IO ()
prependLL (LinkedList ref) x = modifyIORef ref (x:)

deleteLL :: Eq a => LinkedList a -> a -> IO ()
deleteLL (LinkedList ref) x = modifyIORef ref (filter (/= x))

searchLL :: Eq a => LinkedList a -> a -> IO Bool
searchLL (LinkedList ref) x = elem x <$> readIORef ref

toListLL :: LinkedList a -> IO [a]
toListLL (LinkedList ref) = readIORef ref

-- ---------------------------------------------------------------------------
-- Doubly Linked List（IORef + forward list + reverse pointer via paired lists）
-- 実装: forward リストと reverse リスト（常に逆順）を保持
-- ---------------------------------------------------------------------------

data DoublyLinkedList a = DL (IORef [a]) (IORef [a])

newDoublyLinkedList :: IO (DoublyLinkedList a)
newDoublyLinkedList = DL <$> newIORef [] <*> newIORef []

appendDL :: DoublyLinkedList a -> a -> IO ()
appendDL (DL fwd bwd) x = do
  modifyIORef fwd (++ [x])
  modifyIORef bwd (x:)

deleteDL :: Eq a => DoublyLinkedList a -> a -> IO ()
deleteDL (DL fwd bwd) x = do
  modifyIORef fwd (filter (/= x))
  modifyIORef bwd (filter (/= x))

toListDL :: DoublyLinkedList a -> IO [a]
toListDL (DL fwd _) = readIORef fwd

toRevListDL :: DoublyLinkedList a -> IO [a]
toRevListDL (DL _ bwd) = readIORef bwd
