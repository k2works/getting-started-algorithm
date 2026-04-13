package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class LinkedListsTest extends AnyFunSuite with Matchers:

  // ---- SinglyLinkedList ----

  test("SinglyLinkedList: 初期状態は空"):
    val list = SinglyLinkedList[Int]()
    list.isEmpty shouldBe true
    list.size shouldBe 0

  test("SinglyLinkedList: addFirst"):
    val list = SinglyLinkedList[Int]()
    list.addFirst(3); list.addFirst(2); list.addFirst(1)
    list.toList shouldBe List(1, 2, 3)

  test("SinglyLinkedList: addLast"):
    val list = SinglyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.toList shouldBe List(1, 2, 3)

  test("SinglyLinkedList: removeFirst"):
    val list = SinglyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.removeFirst()
    list.toList shouldBe List(2, 3)

  test("SinglyLinkedList: removeLast"):
    val list = SinglyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.removeLast()
    list.toList shouldBe List(1, 2)

  test("SinglyLinkedList: remove"):
    val list = SinglyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.remove(2) shouldBe true
    list.toList shouldBe List(1, 3)
    list.remove(9) shouldBe false

  test("SinglyLinkedList: contains"):
    val list = SinglyLinkedList[Int]()
    list.addLast(1); list.addLast(2)
    list.contains(1) shouldBe true
    list.contains(9) shouldBe false

  test("SinglyLinkedList: 空からの removeFirst は例外"):
    val list = SinglyLinkedList[Int]()
    assertThrows[LinkedListEmptyException](list.removeFirst())

  // ---- DoublyLinkedList ----

  test("DoublyLinkedList: 初期状態は空"):
    val list = DoublyLinkedList[Int]()
    list.isEmpty shouldBe true
    list.size shouldBe 0

  test("DoublyLinkedList: addFirst"):
    val list = DoublyLinkedList[Int]()
    list.addFirst(3); list.addFirst(2); list.addFirst(1)
    list.toList shouldBe List(1, 2, 3)

  test("DoublyLinkedList: addLast"):
    val list = DoublyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.toList shouldBe List(1, 2, 3)

  test("DoublyLinkedList: removeFirst"):
    val list = DoublyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.removeFirst()
    list.toList shouldBe List(2, 3)

  test("DoublyLinkedList: removeLast"):
    val list = DoublyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.removeLast()
    list.toList shouldBe List(1, 2)

  test("DoublyLinkedList: remove"):
    val list = DoublyLinkedList[Int]()
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.remove(2) shouldBe true
    list.toList shouldBe List(1, 3)

  test("DoublyLinkedList: 空からの removeFirst は例外"):
    val list = DoublyLinkedList[Int]()
    assertThrows[LinkedListEmptyException](list.removeFirst())

  // ---- ArrayLinkedList ----

  test("ArrayLinkedList: addFirst"):
    val list = ArrayLinkedList(10)
    list.addFirst(3); list.addFirst(2); list.addFirst(1)
    list.toList shouldBe List(1, 2, 3)

  test("ArrayLinkedList: addLast"):
    val list = ArrayLinkedList(10)
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.toList shouldBe List(1, 2, 3)

  test("ArrayLinkedList: remove"):
    val list = ArrayLinkedList(10)
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.remove(2) shouldBe true
    list.toList shouldBe List(1, 3)
    list.remove(9) shouldBe false

  test("ArrayLinkedList: 削除スロットの再利用"):
    val list = ArrayLinkedList(5)
    list.addLast(1); list.addLast(2); list.addLast(3)
    list.remove(2)
    list.addLast(4)
    list.toList shouldBe List(1, 3, 4)
