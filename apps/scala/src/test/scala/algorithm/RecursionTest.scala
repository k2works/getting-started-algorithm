package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class RecursionTest extends AnyFunSuite with Matchers:

  test("factorial: 基本ケース"):
    Recursion.factorial(0) shouldBe 1
    Recursion.factorial(1) shouldBe 1

  test("factorial: 通常ケース"):
    Recursion.factorial(5) shouldBe 120
    Recursion.factorial(10) shouldBe 3628800

  test("gcd: 最大公約数"):
    Recursion.gcd(12, 8) shouldBe 4
    Recursion.gcd(100, 75) shouldBe 25

  test("gcd: 一方がゼロ"):
    Recursion.gcd(7, 0) shouldBe 7

  test("recursiveSum: 1 から n の和"):
    Recursion.recursiveSum(5) shouldBe 15
    Recursion.recursiveSum(10) shouldBe 55

  test("recursiveSum: n=0"):
    Recursion.recursiveSum(0) shouldBe 0

  test("hanoi: n=1 のハノイの塔"):
    Recursion.hanoi(1, "A", "C", "B") shouldBe List("A->C")

  test("hanoi: n=3 のハノイの塔"):
    val moves = Recursion.hanoi(3, "A", "C", "B")
    moves.length shouldBe 7
    moves.head shouldBe "A->C"
    moves.last shouldBe "A->C"

  test("mazeSolve: 解ける迷路"):
    val maze = Array(
      Array(0, 0, 1),
      Array(1, 0, 1),
      Array(1, 0, 0)
    )
    Recursion.mazeSolve(maze, 0, 0, 2, 2) shouldBe true

  test("mazeSolve: 解けない迷路"):
    val maze = Array(
      Array(0, 1),
      Array(1, 0)
    )
    Recursion.mazeSolve(maze, 0, 0, 1, 1) shouldBe false

  test("EightQueen: 全組み合わせ数 = 8^8"):
    val q = Recursion.EightQueen()
    q.set(0)
    q.getCount shouldBe math.pow(8, 8).toInt

  test("EightQueen2: 行制約あり"):
    val q = Recursion.EightQueen2()
    q.set(0)
    q.getResult.length shouldBe 8 * 7 * 6 * 5 * 4 * 3 * 2 * 1 // 8!

  test("EightQueen3: 完全解は 92 通り"):
    val q = Recursion.EightQueen3()
    q.set(0)
    q.getResult.length shouldBe 92
