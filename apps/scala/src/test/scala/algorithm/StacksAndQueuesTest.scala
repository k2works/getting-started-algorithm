package algorithm

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers

class StacksAndQueuesTest extends AnyFunSuite with Matchers:

  // FixedStack

  test("FixedStack: 初期状態は空"):
    val s = FixedStack[Int](10)
    s.isEmpty shouldBe true
    s.size shouldBe 0

  test("FixedStack: push/pop"):
    val s = FixedStack[Int](10)
    s.push(1); s.push(2); s.push(3)
    s.pop() shouldBe 3
    s.pop() shouldBe 2
    s.pop() shouldBe 1

  test("FixedStack: peek はスタックを変えない"):
    val s = FixedStack[Int](10)
    s.push(42)
    s.peek() shouldBe 42
    s.size shouldBe 1

  test("FixedStack: 空からの pop は例外"):
    val s = FixedStack[Int](5)
    assertThrows[StackEmptyException](s.pop())

  test("FixedStack: 満杯への push は例外"):
    val s = FixedStack[Int](3)
    s.push(1); s.push(2); s.push(3)
    assertThrows[StackFullException](s.push(4))

  test("FixedStack: find/contains/count"):
    val s = FixedStack[Int](10)
    s.push(1); s.push(2); s.push(1)
    s.contains(1) shouldBe true
    s.contains(9) shouldBe false
    s.count(1) shouldBe 2

  test("FixedStack: clear"):
    val s = FixedStack[Int](10)
    s.push(1); s.push(2)
    s.clear()
    s.isEmpty shouldBe true

  test("FixedStack: dump"):
    val s = FixedStack[Int](10)
    s.push(1); s.push(2); s.push(3)
    s.dump() shouldBe Array(1, 2, 3)

  // FixedQueue

  test("FixedQueue: 初期状態は空"):
    val q = FixedQueue[Int](10)
    q.isEmpty shouldBe true
    q.size shouldBe 0

  test("FixedQueue: enqueue/dequeue（FIFO）"):
    val q = FixedQueue[Int](10)
    q.enqueue(1); q.enqueue(2); q.enqueue(3)
    q.dequeue() shouldBe 1
    q.dequeue() shouldBe 2
    q.dequeue() shouldBe 3

  test("FixedQueue: peek はキューを変えない"):
    val q = FixedQueue[Int](10)
    q.enqueue(42)
    q.peek() shouldBe 42
    q.size shouldBe 1

  test("FixedQueue: 空からの dequeue は例外"):
    val q = FixedQueue[Int](5)
    assertThrows[QueueEmptyException](q.dequeue())

  test("FixedQueue: 満杯への enqueue は例外"):
    val q = FixedQueue[Int](3)
    q.enqueue(1); q.enqueue(2); q.enqueue(3)
    assertThrows[QueueFullException](q.enqueue(4))

  test("FixedQueue: リングバッファの動作確認"):
    val q = FixedQueue[Int](3)
    q.enqueue(1); q.enqueue(2); q.dequeue()
    q.enqueue(3); q.enqueue(4)
    q.dequeue() shouldBe 2
    q.dequeue() shouldBe 3
    q.dequeue() shouldBe 4

  test("FixedQueue: find/contains/count"):
    val q = FixedQueue[Int](10)
    q.enqueue(1); q.enqueue(2); q.enqueue(1)
    q.contains(1) shouldBe true
    q.contains(9) shouldBe false
    q.count(1) shouldBe 2

  test("FixedQueue: clear"):
    val q = FixedQueue[Int](10)
    q.enqueue(1); q.enqueue(2)
    q.clear()
    q.isEmpty shouldBe true
