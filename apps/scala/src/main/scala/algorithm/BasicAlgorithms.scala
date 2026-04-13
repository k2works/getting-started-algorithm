package algorithm

/** 第1章 基本的なアルゴリズム */
object BasicAlgorithms:

  /** 3つの整数値の最大値を返す */
  def max3(a: Int, b: Int, c: Int): Int =
    var maximum = a
    if b > maximum then maximum = b
    if c > maximum then maximum = c
    maximum

  /** 3つの整数値の中央値を返す */
  def med3(a: Int, b: Int, c: Int): Int =
    if a >= b then
      if b >= c then b
      else if a <= c then a
      else c
    else if a > c then a
    else if b > c then c
    else b

  /** 整数値の符号を判定する */
  def judgeSign(n: Int): String =
    if n > 0 then "その値は正です。"
    else if n < 0 then "その値は負です。"
    else "その値は0です。"

  /** while 文で 1 から n までの総和を求める */
  def sum1ToNWhile(n: Int): Int =
    var total = 0
    var i = 1
    while i <= n do
      total += i
      i += 1
    total

  /** for 式で 1 から n までの総和を求める */
  def sum1ToNFor(n: Int): Int =
    (1 to n).sum

  /** 記号文字 '+' と '-' を交互に返す（剰余判定方式） */
  def alternative1(n: Int): String =
    (0 until n).map(i => if i % 2 != 0 then '-' else '+').mkString

  /** 記号文字 '+' と '-' を交互に返す（パターン繰り返し方式） */
  def alternative2(n: Int): String =
    "+-" * (n / 2) + (if n % 2 != 0 then "+" else "")

  /** 縦横が整数で面積が area の長方形の辺の長さを列挙する */
  def rectangle(area: Int): String =
    val sb = StringBuilder()
    var i = 1
    while i * i <= area do
      if area % i == 0 then
        sb.append(s"${i}x${area / i} ")
      i += 1
    sb.toString

  /** 九九の表を返す */
  def multiplicationTable(): String =
    val sb = StringBuilder()
    sb.append("-" * 27).append("\n")
    for i <- 1 to 9 do
      for j <- 1 to 9 do
        sb.append(f"${i * j}%3d")
      sb.append("\n")
    sb.append("-" * 27)
    sb.toString

  /** 左下側が直角の二等辺三角形を返す */
  def triangleLb(n: Int): String =
    (1 to n).map(i => "*" * i).mkString("\n") + "\n"
