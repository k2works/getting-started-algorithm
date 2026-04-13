package algorithm

/** 第5章 再帰アルゴリズム */
object Recursion:

  /** 階乗を再帰的に計算 */
  def factorial(n: Int): Int =
    if n <= 0 then 1 else n * factorial(n - 1)

  /** ユークリッドの互除法で最大公約数を求める */
  def gcd(x: Int, y: Int): Int =
    if y == 0 then x else gcd(y, x % y)

  /** 1 から n までの和を再帰的に計算 */
  def recursiveSum(n: Int): Int =
    if n <= 0 then 0 else n + recursiveSum(n - 1)

  /** 真に再帰的な関数（2 箇所で再帰呼び出しを行う） */
  def recure(n: Int): List[Int] =
    if n <= 0 then Nil
    else recure(n - 1) ::: List(n) ::: recure(n - 2)

  /** ハノイの塔: 移動手順をリストで返す */
  def hanoi(n: Int, src: String, dst: String, via: String): List[String] =
    if n == 1 then List(s"$src->$dst")
    else hanoi(n - 1, src, via, dst) ++ List(s"$src->$dst") ++ hanoi(n - 1, via, dst, src)

  /** 迷路をバックトラッキングで解く */
  def mazeSolve(maze: Array[Array[Int]], row: Int, col: Int, goalRow: Int, goalCol: Int): Boolean =
    val visited = Array.ofDim[Boolean](maze.length, maze(0).length)
    def solve(r: Int, c: Int): Boolean =
      if r == goalRow && c == goalCol then true
      else
        visited(r)(c) = true
        val dirs = Array((-1, 0), (1, 0), (0, -1), (0, 1))
        dirs.exists: (dr, dc) =>
          val nr = r + dr; val nc = c + dc
          nr >= 0 && nr < maze.length && nc >= 0 && nc < maze(0).length &&
          maze(nr)(nc) == 0 && !visited(nr)(nc) && solve(nr, nc)
    solve(row, col)

  /** 8 王妃問題（全組み合わせ、制約なし） */
  class EightQueen:
    private var count = 0
    private val pos = new Array[Int](8)
    def set(i: Int): Unit =
      for j <- 0 until 8 do
        pos(i) = j
        if i == 7 then count += 1
        else set(i + 1)
    def getCount: Int = count

  /** 8 王妃問題（行制約あり） */
  class EightQueen2:
    private val result = scala.collection.mutable.ListBuffer[Array[Int]]()
    private val pos    = new Array[Int](8)
    private val flag   = new Array[Boolean](8)
    def set(i: Int): Unit =
      for j <- 0 until 8 do
        if !flag(j) then
          pos(i) = j
          if i == 7 then result += pos.clone()
          else
            flag(j) = true; set(i + 1); flag(j) = false
    def getResult: List[Array[Int]] = result.toList

  /** 8 王妃問題（行・対角線制約あり、完全解） */
  class EightQueen3:
    private val result = scala.collection.mutable.ListBuffer[Array[Int]]()
    private val pos    = new Array[Int](8)
    private val flagA  = new Array[Boolean](8)
    private val flagB  = new Array[Boolean](15)
    private val flagC  = new Array[Boolean](15)
    def set(i: Int): Unit =
      for j <- 0 until 8 do
        if !flagA(j) && !flagB(i + j) && !flagC(i - j + 7) then
          pos(i) = j
          if i == 7 then result += pos.clone()
          else
            flagA(j) = true; flagB(i + j) = true; flagC(i - j + 7) = true
            set(i + 1)
            flagA(j) = false; flagB(i + j) = false; flagC(i - j + 7) = false
    def getResult: List[Array[Int]] = result.toList
