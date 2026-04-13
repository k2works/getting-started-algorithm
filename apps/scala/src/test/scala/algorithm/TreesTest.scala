package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class TreesTest extends AnyFunSuite with Matchers:

  def buildTree(): BinarySearchTree[Int] =
    val bst = BinarySearchTree[Int]()
    List(5, 3, 7, 1, 4, 6, 8).foreach(bst.insert)
    bst

  test("BinarySearchTree: 初期状態は空"):
    val bst = BinarySearchTree[Int]()
    bst.isEmpty shouldBe true
    bst.size shouldBe 0

  test("BinarySearchTree: insert と contains"):
    val bst = buildTree()
    bst.contains(5) shouldBe true
    bst.contains(3) shouldBe true
    bst.contains(8) shouldBe true
    bst.contains(9) shouldBe false

  test("BinarySearchTree: 重複 insert は無視"):
    val bst = buildTree()
    val sizeBefore = bst.size
    bst.insert(5)
    bst.size shouldBe sizeBefore

  test("BinarySearchTree: inOrder（昇順）"):
    val bst = buildTree()
    bst.inOrder() shouldBe List(1, 3, 4, 5, 6, 7, 8)

  test("BinarySearchTree: preOrder"):
    val bst = buildTree()
    bst.preOrder() shouldBe List(5, 3, 1, 4, 7, 6, 8)

  test("BinarySearchTree: postOrder"):
    val bst = buildTree()
    bst.postOrder() shouldBe List(1, 4, 3, 6, 8, 7, 5)

  test("BinarySearchTree: 葉ノードの削除"):
    val bst = buildTree()
    bst.delete(1)
    bst.contains(1) shouldBe false
    bst.inOrder() shouldBe List(3, 4, 5, 6, 7, 8)

  test("BinarySearchTree: 子が 1 つのノードの削除"):
    val bst = BinarySearchTree[Int]()
    List(5, 3, 1).foreach(bst.insert)
    bst.delete(3)
    bst.contains(3) shouldBe false
    bst.inOrder() shouldBe List(1, 5)

  test("BinarySearchTree: 子が 2 つのノードの削除"):
    val bst = buildTree()
    bst.delete(3)
    bst.contains(3) shouldBe false
    bst.inOrder() shouldBe List(1, 4, 5, 6, 7, 8)

  test("BinarySearchTree: ルートの削除"):
    val bst = buildTree()
    bst.delete(5)
    bst.contains(5) shouldBe false
    bst.inOrder() shouldBe List(1, 3, 4, 6, 7, 8)

  test("BinarySearchTree: 存在しないキーの削除"):
    val bst = buildTree()
    val sizeBefore = bst.size
    bst.delete(99)
    bst.size shouldBe sizeBefore

  test("BinarySearchTree: 空の木の走査"):
    val bst = BinarySearchTree[Int]()
    bst.inOrder() shouldBe List.empty
    bst.preOrder() shouldBe List.empty
    bst.postOrder() shouldBe List.empty
