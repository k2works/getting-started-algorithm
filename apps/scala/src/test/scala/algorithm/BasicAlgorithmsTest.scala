package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class BasicAlgorithmsTest extends AnyFunSuite with Matchers:

  test("max3: 各パターンで最大値を返す"):
    val cases = Seq(
      (3, 2, 1, 3), (3, 2, 2, 3), (3, 1, 2, 3),
      (3, 2, 3, 3), (2, 1, 3, 3), (3, 3, 2, 3),
      (3, 3, 3, 3), (2, 2, 3, 3), (2, 3, 1, 3),
      (2, 3, 2, 3), (1, 3, 2, 3), (2, 3, 3, 3),
      (1, 2, 3, 3),
    )
    for (a, b, c, expected) <- cases do
      BasicAlgorithms.max3(a, b, c) shouldBe expected

  test("med3: 各パターンで中央値を返す"):
    val cases = Seq(
      (3, 2, 1, 2), (3, 2, 2, 2), (3, 1, 2, 2),
      (3, 2, 3, 3), (2, 1, 3, 2), (3, 3, 2, 3),
      (3, 3, 3, 3), (2, 2, 3, 2), (2, 3, 1, 2),
      (2, 3, 2, 2), (1, 3, 2, 2), (2, 3, 3, 3),
      (1, 2, 3, 2),
    )
    for (a, b, c, expected) <- cases do
      BasicAlgorithms.med3(a, b, c) shouldBe expected

  test("judgeSign: 正の値"):
    BasicAlgorithms.judgeSign(17) shouldBe "その値は正です。"

  test("judgeSign: 負の値"):
    BasicAlgorithms.judgeSign(-5) shouldBe "その値は負です。"

  test("judgeSign: ゼロ"):
    BasicAlgorithms.judgeSign(0) shouldBe "その値は0です。"

  test("sum1ToNWhile: while 文で総和"):
    BasicAlgorithms.sum1ToNWhile(5) shouldBe 15

  test("sum1ToNFor: for 式で総和"):
    BasicAlgorithms.sum1ToNFor(5) shouldBe 15

  test("alternative1: 剰余判定方式で 12 文字"):
    BasicAlgorithms.alternative1(12) shouldBe "+-+-+-+-+-+-"

  test("alternative2: パターン繰り返し方式で 12 文字"):
    BasicAlgorithms.alternative2(12) shouldBe "+-+-+-+-+-+-"

  test("alternative: 奇数文字"):
    BasicAlgorithms.alternative1(5) shouldBe "+-+-+"
    BasicAlgorithms.alternative2(5) shouldBe "+-+-+"

  test("rectangle: 面積 32 の長方形"):
    BasicAlgorithms.rectangle(32) shouldBe "1x32 2x16 4x8 "

  test("multiplicationTable: 九九の表"):
    val expected =
      "---------------------------\n" +
      "  1  2  3  4  5  6  7  8  9\n" +
      "  2  4  6  8 10 12 14 16 18\n" +
      "  3  6  9 12 15 18 21 24 27\n" +
      "  4  8 12 16 20 24 28 32 36\n" +
      "  5 10 15 20 25 30 35 40 45\n" +
      "  6 12 18 24 30 36 42 48 54\n" +
      "  7 14 21 28 35 42 49 56 63\n" +
      "  8 16 24 32 40 48 56 64 72\n" +
      "  9 18 27 36 45 54 63 72 81\n" +
      "---------------------------"
    BasicAlgorithms.multiplicationTable() shouldBe expected

  test("triangleLb: 直角三角形"):
    BasicAlgorithms.triangleLb(5) shouldBe "*\n**\n***\n****\n*****\n"
