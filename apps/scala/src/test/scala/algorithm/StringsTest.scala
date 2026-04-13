package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class StringsTest extends AnyFunSuite with Matchers:

  test("bfMatch: パターンが見つかる"):
    Strings.bfMatch("ABCDEF", "CDE") shouldBe 2

  test("bfMatch: パターンが見つからない"):
    Strings.bfMatch("ABCDEF", "XYZ") shouldBe -1

  test("bfMatch: 空パターン"):
    Strings.bfMatch("ABCDEF", "") shouldBe 0

  test("kmpMatch: パターンが見つかる"):
    Strings.kmpMatch("AABCAABAACAABC", "AABC") shouldBe 0

  test("kmpMatch: パターンが見つからない"):
    Strings.kmpMatch("ABCDEF", "XYZ") shouldBe -1

  test("kmpMatch: 重複パターン"):
    Strings.kmpMatch("AABAACAADAABAABA", "AABA") shouldBe 0

  test("bmMatch: パターンが見つかる"):
    Strings.bmMatch("ABCDEF", "CDE") shouldBe 2

  test("bmMatch: パターンが見つからない"):
    Strings.bmMatch("ABCDEF", "XYZ") shouldBe -1

  test("countChars: 各文字の出現回数"):
    val result = Strings.countChars("aabbc")
    result('a') shouldBe 2
    result('b') shouldBe 2
    result('c') shouldBe 1

  test("reverseString: 文字列を逆順に"):
    Strings.reverseString("hello") shouldBe "olleh"
    Strings.reverseString("") shouldBe ""

  test("isPalindrome: 回文"):
    Strings.isPalindrome("racecar") shouldBe true
    Strings.isPalindrome("level") shouldBe true

  test("isPalindrome: 非回文"):
    Strings.isPalindrome("hello") shouldBe false

  test("isPalindrome: 空文字列"):
    Strings.isPalindrome("") shouldBe true
