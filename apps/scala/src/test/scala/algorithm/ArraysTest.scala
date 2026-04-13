package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class ArraysTest extends AnyFunSuite with Matchers:

  test("maxOf: 配列の最大値"):
    Arrays.maxOf(Array(3, 1, 4, 1, 5, 9, 2, 6)) shouldBe 9

  test("reverse: 配列を反転する"):
    val a = Array(1, 2, 3, 4, 5)
    Arrays.reverse(a)
    a shouldBe Array(5, 4, 3, 2, 1)

  test("reverse: 偶数長の配列"):
    val a = Array(1, 2, 3, 4)
    Arrays.reverse(a)
    a shouldBe Array(4, 3, 2, 1)

  test("cardConv: 10進数を2進数に変換"):
    Arrays.cardConv(29, 2) shouldBe "11101"

  test("cardConv: 10進数を16進数に変換"):
    Arrays.cardConv(255, 16) shouldBe "FF"

  test("cardConv: 10進数を8進数に変換"):
    Arrays.cardConv(100, 8) shouldBe "144"

  test("prime1: 素数列挙（第1版）の除算回数"):
    Arrays.prime1(1000) shouldBe 78022

  test("prime2: 素数列挙（第2版）の除算回数"):
    Arrays.prime2(1000) shouldBe 14622

  test("prime3: 素数列挙（第3版）の除算回数"):
    Arrays.prime3(1000) shouldBe 3774

  test("prime 各版の効率比較: prime3 が最も少ない除算回数"):
    Arrays.prime3(1000) < Arrays.prime2(1000) shouldBe true
    Arrays.prime2(1000) < Arrays.prime1(1000) shouldBe true
