package algorithm

import scala.collection.mutable

/** 第3章 探索アルゴリズム */
object SearchAlgorithms:

  /** 線形探索（while 文） */
  def linearSearchWhile(a: Array[Int], key: Int): Int =
    var i = 0
    while true do
      if i == a.length then return -1
      if a(i) == key then return i
      i += 1
    -1

  /** 線形探索（for 式） */
  def linearSearchFor(a: Array[Int], key: Int): Int =
    for i <- a.indices do
      if a(i) == key then return i
    -1

  /** 線形探索（番兵法） */
  def linearSearchSentinel(a: Array[Int], key: Int): Int =
    val b = a :+ key // 末尾に番兵を追加
    var i = 0
    while b(i) != key do i += 1
    if i == a.length then -1 else i

  /** 二分探索 */
  def binarySearch(a: Array[Int], key: Int): Int =
    var pl = 0
    var pr = a.length - 1
    while pl <= pr do
      val pc = (pl + pr) / 2
      if a(pc) == key then return pc
      else if a(pc) < key then pl = pc + 1
      else pr = pc - 1
    -1

  /** チェイン法ハッシュテーブル */
  class ChainedHash(capacity: Int):
    private case class Node(key: Int, value: String, var next: Node | Null = null)
    private val table = new Array[Node | Null](capacity)

    private def hashValue(key: Int): Int = key % capacity

    def search(key: Int): Option[String] =
      var p = table(hashValue(key))
      while p != null do
        if p.key == key then return Some(p.value)
        p = p.next
      None

    def add(key: Int, value: String): Boolean =
      val h = hashValue(key)
      var p = table(h)
      while p != null do
        if p.key == key then return false
        p = p.next
      table(h) = Node(key, value, table(h))
      true

    def remove(key: Int): Boolean =
      val h = hashValue(key)
      var p = table(h)
      var pp: Node | Null = null
      while p != null do
        if p.key == key then
          if pp == null then table(h) = p.next
          else pp.next = p.next
          return true
        pp = p
        p = p.next
      false

  /** オープンアドレス法（線形探索法）ハッシュテーブル */
  class OpenHash(capacity: Int):
    private enum Status { case Occupied, Empty, Deleted }
    private case class Bucket(var key: Int = 0, var value: String = "", var stat: Status = Status.Empty)

    private val table = Array.fill(capacity)(Bucket())

    private def hashValue(key: Int): Int = key % capacity

    def search(key: Int): Option[String] =
      var h = hashValue(key)
      for _ <- 0 until capacity do
        val p = table(h)
        if p.stat == Status.Empty then return None
        if p.stat == Status.Occupied && p.key == key then return Some(p.value)
        h = (h + 1) % capacity
      None

    def add(key: Int, value: String): Boolean =
      if search(key).isDefined then return false
      var h = hashValue(key)
      for _ <- 0 until capacity do
        val p = table(h)
        if p.stat == Status.Empty || p.stat == Status.Deleted then
          table(h) = Bucket(key, value, Status.Occupied)
          return true
        h = (h + 1) % capacity
      false

    def remove(key: Int): Boolean =
      var h = hashValue(key)
      for _ <- 0 until capacity do
        val p = table(h)
        if p.stat == Status.Empty then return false
        if p.stat == Status.Occupied && p.key == key then
          table(h) = Bucket(stat = Status.Deleted)
          return true
        h = (h + 1) % capacity
      false
