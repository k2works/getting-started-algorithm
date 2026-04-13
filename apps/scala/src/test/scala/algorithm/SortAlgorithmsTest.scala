package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class SortAlgorithmsTest extends AnyFunSuite with Matchers:

  val unsorted  = Array(5, 3, 8, 1, 9, 2, 7, 4, 6)
  val ascending = Array(1, 2, 3, 4, 5, 6, 7, 8, 9)

  test("bubbleSort"):
    val a = unsorted.clone()
    SortAlgorithms.bubbleSort(a)
    a shouldBe ascending

  test("selectionSort"):
    val a = unsorted.clone()
    SortAlgorithms.selectionSort(a)
    a shouldBe ascending

  test("insertionSort"):
    val a = unsorted.clone()
    SortAlgorithms.insertionSort(a)
    a shouldBe ascending

  test("shellSort"):
    val a = unsorted.clone()
    SortAlgorithms.shellSort(a)
    a shouldBe ascending

  test("quickSort"):
    val a = unsorted.clone()
    SortAlgorithms.quickSort(a)
    a shouldBe ascending

  test("mergeSort"):
    SortAlgorithms.mergeSort(unsorted) shouldBe ascending

  test("heapSort"):
    val a = unsorted.clone()
    SortAlgorithms.heapSort(a)
    a shouldBe ascending

  test("countingSort"):
    SortAlgorithms.countingSort(unsorted) shouldBe ascending

  test("ソート: 空配列"):
    SortAlgorithms.bubbleSort(Array.empty[Int])
    SortAlgorithms.selectionSort(Array.empty[Int])
    SortAlgorithms.insertionSort(Array.empty[Int])
    SortAlgorithms.mergeSort(Array.empty[Int]) shouldBe Array.empty[Int]
    SortAlgorithms.countingSort(Array.empty[Int]) shouldBe Array.empty[Int]

  test("ソート: 要素が 1 つ"):
    val a = Array(42)
    SortAlgorithms.bubbleSort(a)
    a shouldBe Array(42)

  test("ソート: 重複あり"):
    val a = Array(3, 1, 4, 1, 5, 9, 2, 6, 5)
    SortAlgorithms.bubbleSort(a)
    a shouldBe Array(1, 1, 2, 3, 4, 5, 5, 6, 9)
