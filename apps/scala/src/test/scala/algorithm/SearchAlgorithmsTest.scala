package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class SearchAlgorithmsTest extends AnyFunSuite with Matchers:

  val arr = Array(1, 3, 5, 7, 9, 11, 13, 15)

  test("linearSearchWhile: キーが見つかる"):
    SearchAlgorithms.linearSearchWhile(arr, 7) shouldBe 3

  test("linearSearchWhile: キーが見つからない"):
    SearchAlgorithms.linearSearchWhile(arr, 6) shouldBe -1

  test("linearSearchFor: キーが見つかる"):
    SearchAlgorithms.linearSearchFor(arr, 5) shouldBe 2

  test("linearSearchFor: キーが見つからない"):
    SearchAlgorithms.linearSearchFor(arr, 2) shouldBe -1

  test("linearSearchSentinel: キーが見つかる"):
    SearchAlgorithms.linearSearchSentinel(arr, 9) shouldBe 4

  test("linearSearchSentinel: キーが見つからない"):
    SearchAlgorithms.linearSearchSentinel(arr, 4) shouldBe -1

  test("binarySearch: キーが見つかる"):
    SearchAlgorithms.binarySearch(arr, 11) shouldBe 5

  test("binarySearch: キーが見つからない"):
    SearchAlgorithms.binarySearch(arr, 10) shouldBe -1

  test("binarySearch: 先頭要素"):
    SearchAlgorithms.binarySearch(arr, 1) shouldBe 0

  test("binarySearch: 末尾要素"):
    SearchAlgorithms.binarySearch(arr, 15) shouldBe 7

  test("ChainedHash: 追加と検索"):
    val h = SearchAlgorithms.ChainedHash(13)
    h.add(1, "one") shouldBe true
    h.add(14, "fourteen") shouldBe true
    h.search(1) shouldBe Some("one")
    h.search(14) shouldBe Some("fourteen")
    h.search(999) shouldBe None

  test("ChainedHash: 重複追加は失敗"):
    val h = SearchAlgorithms.ChainedHash(13)
    h.add(1, "one") shouldBe true
    h.add(1, "one-dup") shouldBe false

  test("ChainedHash: 削除"):
    val h = SearchAlgorithms.ChainedHash(13)
    h.add(1, "one")
    h.remove(1) shouldBe true
    h.search(1) shouldBe None
    h.remove(1) shouldBe false

  test("OpenHash: 追加と検索"):
    val h = SearchAlgorithms.OpenHash(13)
    h.add(1, "one") shouldBe true
    h.search(1) shouldBe Some("one")
    h.search(999) shouldBe None

  test("OpenHash: 重複追加は失敗"):
    val h = SearchAlgorithms.OpenHash(13)
    h.add(1, "one") shouldBe true
    h.add(1, "one-dup") shouldBe false

  test("OpenHash: 削除"):
    val h = SearchAlgorithms.OpenHash(13)
    h.add(1, "one")
    h.remove(1) shouldBe true
    h.search(1) shouldBe None
    h.remove(1) shouldBe false
