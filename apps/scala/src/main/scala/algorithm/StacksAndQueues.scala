package algorithm

import scala.collection.mutable.ArrayBuffer

/** 第4章 スタックとキュー */

class StackEmptyException extends RuntimeException("スタックは空です")
class StackFullException  extends RuntimeException("スタックは満杯です")
class QueueEmptyException extends RuntimeException("キューは空です")
class QueueFullException  extends RuntimeException("キューは満杯です")

/** 固定長スタック */
class FixedStack[T](capacity: Int):
  private val stk = new Array[Any](capacity)
  private var ptr = 0

  def isEmpty: Boolean = ptr <= 0
  def isFull:  Boolean = ptr >= capacity
  def size:    Int     = ptr
  def getCapacity: Int = capacity

  def push(value: T): Unit =
    if isFull then throw StackFullException()
    stk(ptr) = value
    ptr += 1

  def pop(): T =
    if isEmpty then throw StackEmptyException()
    ptr -= 1
    stk(ptr).asInstanceOf[T]

  def peek(): T =
    if isEmpty then throw StackEmptyException()
    stk(ptr - 1).asInstanceOf[T]

  def find(value: T): Int =
    (ptr - 1 to 0 by -1).find(i => stk(i) == value).getOrElse(-1)

  def contains(value: T): Boolean = find(value) != -1

  def count(value: T): Int =
    (0 until ptr).count(i => stk(i) == value)

  def clear(): Unit = ptr = 0

  def dump(): Array[Any] = stk.take(ptr)

/** 固定長キュー（リングバッファ） */
class FixedQueue[T](capacity: Int):
  private val que  = new Array[Any](capacity)
  private var front = 0
  private var rear  = 0
  private var num   = 0

  def isEmpty: Boolean = num <= 0
  def isFull:  Boolean = num >= capacity
  def size:    Int     = num
  def getCapacity: Int = capacity

  def enqueue(value: T): Unit =
    if isFull then throw QueueFullException()
    que(rear) = value
    rear += 1
    num  += 1
    if rear == capacity then rear = 0

  def dequeue(): T =
    if isEmpty then throw QueueEmptyException()
    val value = que(front).asInstanceOf[T]
    front += 1
    num   -= 1
    if front == capacity then front = 0
    value

  def peek(): T =
    if isEmpty then throw QueueEmptyException()
    que(front).asInstanceOf[T]

  def find(value: T): Int =
    (0 until num).find(i => que((i + front) % capacity) == value).getOrElse(-1)

  def contains(value: T): Boolean = find(value) != -1

  def count(value: T): Int =
    (0 until num).count(i => que((i + front) % capacity) == value)

  def clear(): Unit =
    front = 0; rear = 0; num = 0
