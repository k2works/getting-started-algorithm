package algorithm

/** 第7章 文字列処理 */
object Strings:

  /** ブルートフォース文字列探索 */
  def bfMatch(txt: String, pat: String): Int =
    val n = txt.length; val m = pat.length
    if m == 0 then return 0
    for i <- 0 to n - m do
      var j = 0
      while j < m && txt(i + j) == pat(j) do j += 1
      if j == m then return i
    -1

  /** KMP 文字列探索 */
  def kmpMatch(txt: String, pat: String): Int =
    val n = txt.length; val m = pat.length
    if m == 0 then return 0
    val table = buildKmpTable(pat)
    var j = 0
    for i <- 0 until n do
      while j > 0 && txt(i) != pat(j) do j = table(j - 1)
      if txt(i) == pat(j) then j += 1
      if j == m then return i - m + 1
    -1

  private def buildKmpTable(pat: String): Array[Int] =
    val m = pat.length
    val table = new Array[Int](m)
    var k = 0
    for i <- 1 until m do
      while k > 0 && pat(k) != pat(i) do k = table(k - 1)
      if pat(k) == pat(i) then k += 1
      table(i) = k
    table

  /** Boyer-Moore 文字列探索（Bad Character ルールのみ） */
  def bmMatch(txt: String, pat: String): Int =
    val n = txt.length; val m = pat.length
    if m == 0 then return 0
    val badChar = pat.zipWithIndex.toMap
    var s = 0
    while s <= n - m do
      var j = m - 1
      while j >= 0 && pat(j) == txt(s + j) do j -= 1
      if j < 0 then return s
      val skip = j - badChar.getOrElse(txt(s + j), -1)
      s += math.max(1, skip)
    -1

  /** 文字列中の各文字の出現回数を返す */
  def countChars(s: String): Map[Char, Int] =
    s.groupBy(identity).view.mapValues(_.length).toMap

  /** 文字列を逆順にして返す */
  def reverseString(s: String): String = s.reverse

  /** 文字列が回文かどうかを判定 */
  def isPalindrome(s: String): Boolean = s == s.reverse
