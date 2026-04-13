package algorithm

import scala.collection.mutable.ArrayBuffer

/** 第9章 木構造 */

class BSTEmptyException extends RuntimeException("木は空です")

/** 二分探索木 */
class BinarySearchTree[T: Ordering]:
  import Ordering.Implicits.*

  private class Node(var key: T, var left: Node | Null = null, var right: Node | Null = null)

  private var root: Node | Null = null
  private var _size = 0

  def size: Int    = _size
  def isEmpty: Boolean = root == null
  def contains(key: T): Boolean = search(key) != null

  private def search(key: T): Node | Null =
    var ptr = root
    while ptr != null do
      val cmp = summon[Ordering[T]].compare(key, ptr.key)
      if cmp == 0 then return ptr
      ptr = if cmp < 0 then ptr.left else ptr.right
    null

  def insert(key: T): Unit =
    if root == null then { root = Node(key); _size += 1; return }
    var ptr = root
    while true do
      val cmp = summon[Ordering[T]].compare(key, ptr.key)
      if cmp == 0 then return // 重複は無視
      if cmp < 0 then
        if ptr.left == null then { ptr.left = Node(key); _size += 1; return }
        ptr = ptr.left
      else
        if ptr.right == null then { ptr.right = Node(key); _size += 1; return }
        ptr = ptr.right

  def delete(key: T): Unit =
    var parent: Node | Null = null
    var ptr = root
    var isLeftChild = false
    while ptr != null do
      val cmp = summon[Ordering[T]].compare(key, ptr.key)
      if cmp == 0 then
        ptr = null // break
      else
        parent = ptr
        if cmp < 0 then { isLeftChild = true;  ptr = ptr.left  }
        else             { isLeftChild = false; ptr = ptr.right }

    val node = search(key)
    if node == null then return
    _size -= 1

    def replace(child: Node | Null): Unit =
      if parent == null then root = child
      else if isLeftChild then parent.left = child
      else parent.right = child

    if node.left == null && node.right == null then replace(null)
    else if node.right == null then replace(node.left)
    else if node.left == null then replace(node.right)
    else
      var succParent = node
      var succ = node.right
      while succ.left != null do
        succParent = succ; succ = succ.left
      node.key = succ.key
      if succParent == node then succParent.right = succ.right
      else succParent.left = succ.right

  def inOrder(): List[T] =
    val result = ArrayBuffer[T]()
    def traverse(n: Node | Null): Unit =
      if n != null then
        traverse(n.left); result += n.key; traverse(n.right)
    traverse(root)
    result.toList

  def preOrder(): List[T] =
    val result = ArrayBuffer[T]()
    def traverse(n: Node | Null): Unit =
      if n != null then
        result += n.key; traverse(n.left); traverse(n.right)
    traverse(root)
    result.toList

  def postOrder(): List[T] =
    val result = ArrayBuffer[T]()
    def traverse(n: Node | Null): Unit =
      if n != null then
        traverse(n.left); traverse(n.right); result += n.key
    traverse(root)
    result.toList
