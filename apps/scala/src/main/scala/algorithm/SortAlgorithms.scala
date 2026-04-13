package algorithm

/** 第6章 ソートアルゴリズム */
object SortAlgorithms:

  /** バブルソート（in-place） */
  def bubbleSort(a: Array[Int]): Unit =
    val n = a.length
    var i = 0
    while i < n - 1 do
      var swapped = false
      var j = n - 1
      while j > i do
        if a(j - 1) > a(j) then
          val tmp = a(j - 1); a(j - 1) = a(j); a(j) = tmp
          swapped = true
        j -= 1
      if !swapped then i = n // break
      i += 1

  /** 選択ソート（in-place） */
  def selectionSort(a: Array[Int]): Unit =
    val n = a.length
    for i <- 0 until n - 1 do
      var minIdx = i
      for j <- i + 1 until n do
        if a(j) < a(minIdx) then minIdx = j
      if minIdx != i then
        val tmp = a(i); a(i) = a(minIdx); a(minIdx) = tmp

  /** 挿入ソート（in-place） */
  def insertionSort(a: Array[Int]): Unit =
    val n = a.length
    for i <- 1 until n do
      val key = a(i)
      var j = i - 1
      while j >= 0 && a(j) > key do
        a(j + 1) = a(j)
        j -= 1
      a(j + 1) = key

  /** シェルソート（in-place、Knuth 数列） */
  def shellSort(a: Array[Int]): Unit =
    val n = a.length
    var gap = 1
    while gap * 3 + 1 < n do gap = gap * 3 + 1
    while gap > 0 do
      for i <- gap until n do
        val key = a(i)
        var j = i - gap
        while j >= 0 && a(j) > key do
          a(j + gap) = a(j)
          j -= gap
        a(j + gap) = key
      gap /= 3

  /** クイックソート（in-place） */
  def quickSort(a: Array[Int], left: Int, right: Int): Unit =
    if left < right then
      val pivot = a((left + right) / 2)
      var i = left; var j = right
      while i <= j do
        while a(i) < pivot do i += 1
        while a(j) > pivot do j -= 1
        if i <= j then
          val tmp = a(i); a(i) = a(j); a(j) = tmp
          i += 1; j -= 1
      quickSort(a, left, j)
      quickSort(a, i, right)

  def quickSort(a: Array[Int]): Unit =
    if a.length > 1 then quickSort(a, 0, a.length - 1)

  /** マージソート（新しい配列を返す） */
  def mergeSort(a: Array[Int]): Array[Int] =
    if a.length <= 1 then a.clone()
    else
      val mid   = a.length / 2
      val left  = mergeSort(a.slice(0, mid))
      val right = mergeSort(a.slice(mid, a.length))
      merge(left, right)

  private def merge(left: Array[Int], right: Array[Int]): Array[Int] =
    val result = new Array[Int](left.length + right.length)
    var i = 0; var j = 0; var k = 0
    while i < left.length && j < right.length do
      if left(i) <= right(j) then { result(k) = left(i); i += 1 }
      else { result(k) = right(j); j += 1 }
      k += 1
    while i < left.length do  { result(k) = left(i);  i += 1; k += 1 }
    while j < right.length do { result(k) = right(j); j += 1; k += 1 }
    result

  /** ヒープソート（in-place） */
  def heapSort(a: Array[Int]): Unit =
    val n = a.length
    if n <= 1 then return
    for i <- (n - 1) / 2 to 0 by -1 do downHeap(a, i, n - 1)
    for i <- n - 1 to 1 by -1 do
      val tmp = a(0); a(0) = a(i); a(i) = tmp
      downHeap(a, 0, i - 1)

  private def downHeap(a: Array[Int], left: Int, right: Int): Unit =
    val temp = a(left)
    var parent = left
    var running = true
    while running && parent < (right + 1) / 2 do
      val cl = parent * 2 + 1
      val cr = cl + 1
      val child = if cr <= right && a(cr) > a(cl) then cr else cl
      if temp >= a(child) then running = false
      else
        a(parent) = a(child)
        parent = child
    a(parent) = temp

  /** 度数ソート（計数ソート）-- 新しい配列を返す */
  def countingSort(a: Array[Int]): Array[Int] =
    if a.isEmpty then return Array.empty
    val maxVal = a.max
    val freq = new Array[Int](maxVal + 1)
    for x <- a do freq(x) += 1
    for i <- 1 until freq.length do freq(i) += freq(i - 1)
    val result = new Array[Int](a.length)
    for i <- a.length - 1 to 0 by -1 do
      freq(a(i)) -= 1
      result(freq(a(i))) = a(i)
    result
