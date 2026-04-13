package algorithm

import scala.collection.mutable.ArrayBuffer

/** 第8章 連結リスト */

class LinkedListEmptyException extends RuntimeException("リストは空です")

// ---- 単方向連結リスト ----

private class SNode[T](val data: T, var next: SNode[T] | Null = null)

class SinglyLinkedList[T]:
  private var head: SNode[T] | Null = null
  private var _size = 0

  def size: Int    = _size
  def isEmpty: Boolean = head == null

  def contains(data: T): Boolean = search(data).isDefined

  private def search(data: T): Option[SNode[T]] =
    var ptr = head
    while ptr != null do
      if ptr.data == data then return Some(ptr)
      ptr = ptr.next
    None

  def addFirst(data: T): Unit =
    head = SNode(data, head)
    _size += 1

  def addLast(data: T): Unit =
    if head == null then head = SNode(data)
    else
      var ptr = head
      while ptr.next != null do ptr = ptr.next
      ptr.next = SNode(data)
    _size += 1

  def removeFirst(): Unit =
    if head == null then throw LinkedListEmptyException()
    head = head.next
    _size -= 1

  def removeLast(): Unit =
    if head == null then throw LinkedListEmptyException()
    if head.next == null then head = null
    else
      var ptr = head
      while ptr.next != null && ptr.next.next != null do ptr = ptr.next
      ptr.next = null
    _size -= 1

  def remove(data: T): Boolean =
    if head == null then return false
    if head.data == data then
      head = head.next; _size -= 1; return true
    var ptr = head
    while ptr.next != null do
      if ptr.next.data == data then
        ptr.next = ptr.next.next; _size -= 1; return true
      ptr = ptr.next
    false

  def toList: List[T] =
    val buf = ArrayBuffer[T]()
    var ptr = head
    while ptr != null do
      buf += ptr.data
      ptr = ptr.next
    buf.toList

// ---- 双方向連結リスト（番兵ノード使用）----

private class DNode[T](val data: T, var prev: DNode[T] | Null = null, var next: DNode[T] | Null = null)

class DoublyLinkedList[T]:
  private val sentinel: DNode[T] = DNode(null.asInstanceOf[T])
  sentinel.prev = sentinel
  sentinel.next = sentinel
  private var _size = 0

  def size: Int    = _size
  def isEmpty: Boolean = sentinel.next == sentinel

  def addFirst(data: T): Unit =
    val node = DNode(data)
    node.prev = sentinel
    node.next = sentinel.next
    sentinel.next.prev = node
    sentinel.next = node
    _size += 1

  def addLast(data: T): Unit =
    val node = DNode(data)
    node.prev = sentinel.prev
    node.next = sentinel
    sentinel.prev.next = node
    sentinel.prev = node
    _size += 1

  def removeFirst(): Unit =
    if isEmpty then throw LinkedListEmptyException()
    val node = sentinel.next
    sentinel.next = node.next
    node.next.prev = sentinel
    _size -= 1

  def removeLast(): Unit =
    if isEmpty then throw LinkedListEmptyException()
    val node = sentinel.prev
    sentinel.prev = node.prev
    node.prev.next = sentinel
    _size -= 1

  def remove(data: T): Boolean =
    var ptr = sentinel.next
    while ptr != sentinel do
      if ptr.data == data then
        ptr.prev.next = ptr.next
        ptr.next.prev = ptr.prev
        _size -= 1
        return true
      ptr = ptr.next
    false

  def toList: List[T] =
    val buf = ArrayBuffer[T]()
    var ptr = sentinel.next
    while ptr != sentinel do
      buf += ptr.data
      ptr = ptr.next
    buf.toList

// ---- 配列による連結リスト（カーソル版）----

class ArrayLinkedList(capacity: Int):
  private val Null = -1
  private val data  = new Array[Int](capacity)
  private val next  = Array.fill(capacity)(Null)
  private val dnext = Array.fill(capacity)(Null)
  private var head    = Null
  private var maxUsed = Null
  private var deleted = Null

  private def getIndex(): Int =
    if deleted != Null then
      val idx = deleted
      deleted = dnext(deleted)
      idx
    else
      maxUsed += 1
      maxUsed

  def addFirst(value: Int): Unit =
    val idx = getIndex()
    data(idx) = value
    next(idx) = head
    head = idx

  def addLast(value: Int): Unit =
    val idx = getIndex()
    data(idx) = value
    next(idx) = Null
    if head == Null then head = idx
    else
      var ptr = head
      while next(ptr) != Null do ptr = next(ptr)
      next(ptr) = idx

  def remove(value: Int): Boolean =
    if head == Null then return false
    if data(head) == value then
      val old = head
      head = next(head)
      dnext(old) = deleted; deleted = old
      return true
    var ptr = head
    while next(ptr) != Null do
      if data(next(ptr)) == value then
        val old = next(ptr)
        next(ptr) = next(old)
        dnext(old) = deleted; deleted = old
        return true
      ptr = next(ptr)
    false

  def toList: List[Int] =
    val buf = ArrayBuffer[Int]()
    var ptr = head
    while ptr != Null do
      buf += data(ptr)
      ptr = next(ptr)
    buf.toList
