package algorithm

/** 第2章 配列 */
object Arrays:

  /** 配列の要素の最大値を返す */
  def maxOf(a: Array[Int]): Int =
    a.max

  /** 配列の要素の並びを反転する（in-place） */
  def reverse(a: Array[Int]): Unit =
    val n = a.length
    for i <- 0 until n / 2 do
      val tmp = a(i)
      a(i) = a(n - i - 1)
      a(n - i - 1) = tmp

  /** 整数値 x を r 進数に変換した文字列を返す */
  def cardConv(x: Int, r: Int): String =
    val dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var n = x
    val sb = StringBuilder()
    while n > 0 do
      sb.append(dchar(n % r))
      n /= r
    sb.reverse.toString

  /** x 以下の素数を列挙する（第1版）-- 除算回数を返す */
  def prime1(x: Int): Int =
    var counter = 0
    for n <- 2 to x do
      var i = 2
      var running = true
      while i < n && running do
        counter += 1
        if n % i == 0 then running = false
        i += 1
    counter

  /** x 以下の素数を列挙する（第2版）-- 除算回数を返す */
  def prime2(x: Int): Int =
    var counter = 0
    val prime = new Array[Int](500)
    var ptr = 0
    prime(ptr) = 2
    ptr += 1
    var n = 3
    while n <= x do
      var i = 1
      var found = false
      var running = true
      while i < ptr && running do
        counter += 1
        if n % prime(i) == 0 then
          found = true
          running = false
        i += 1
      if !found then
        prime(ptr) = n
        ptr += 1
      n += 2
    counter

  /** x 以下の素数を列挙する（第3版）-- 除算回数を返す */
  def prime3(x: Int): Int =
    var counter = 0
    val prime = new Array[Int](500)
    var ptr = 0
    prime(ptr) = 2; ptr += 1
    prime(ptr) = 3; ptr += 1
    var n = 5
    while n <= 1000 do
      var isPrime = true
      var i = 1
      var innerRunning = true
      while innerRunning && prime(i) * prime(i) <= n do
        counter += 2
        if n % prime(i) == 0 then
          isPrime = false
          innerRunning = false
        else
          i += 1
      if isPrime then
        prime(ptr) = n
        ptr += 1
        counter += 1
      n += 2
    counter
