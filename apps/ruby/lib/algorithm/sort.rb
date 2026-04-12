# frozen_string_literal: true

# 第6章 ソートアルゴリズム

module Algorithm
  # バブルソート（in-place）
  def self.bubble_sort(a)
    n = a.length
    (n - 1).times do |i|
      swapped = false
      (n - 1).downto(i + 1) do |j|
        if a[j - 1] > a[j]
          a[j - 1], a[j] = a[j], a[j - 1]
          swapped = true
        end
      end
      break unless swapped
    end
  end

  # 選択ソート（in-place）
  def self.selection_sort(a)
    n = a.length
    (n - 1).times do |i|
      min_idx = i
      (i + 1...n).each do |j|
        min_idx = j if a[j] < a[min_idx]
      end
      a[i], a[min_idx] = a[min_idx], a[i] if min_idx != i
    end
  end

  # 挿入ソート（in-place）
  def self.insertion_sort(a)
    n = a.length
    (1...n).each do |i|
      key = a[i]
      j = i - 1
      while j >= 0 && a[j] > key
        a[j + 1] = a[j]
        j -= 1
      end
      a[j + 1] = key
    end
  end

  # シェルソート（in-place, Knuth 数列）
  def self.shell_sort(a)
    n = a.length
    gap = 1
    gap = gap * 3 + 1 while gap * 3 + 1 < n

    while gap > 0
      (gap...n).each do |i|
        key = a[i]
        j = i - gap
        while j >= 0 && a[j] > key
          a[j + gap] = a[j]
          j -= gap
        end
        a[j + gap] = key
      end
      gap /= 3
    end
  end

  # クイックソート（in-place）
  def self.quick_sort(a, left = 0, right = nil)
    right ||= a.length - 1
    return if left >= right

    pivot = a[(left + right) / 2]
    i = left
    j = right

    while i <= j
      i += 1 while a[i] < pivot
      j -= 1 while a[j] > pivot
      if i <= j
        a[i], a[j] = a[j], a[i]
        i += 1
        j -= 1
      end
    end

    quick_sort(a, left, j)
    quick_sort(a, i, right)
  end

  # マージソート（新しい配列を返す）
  def self.merge_sort(a)
    return a.dup if a.length <= 1

    mid = a.length / 2
    left = merge_sort(a[0...mid])
    right = merge_sort(a[mid..])
    _merge(left, right)
  end

  def self._merge(left, right)
    result = []
    i = j = 0
    while i < left.length && j < right.length
      if left[i] <= right[j]
        result << left[i]
        i += 1
      else
        result << right[j]
        j += 1
      end
    end
    result.concat(left[i..])
    result.concat(right[j..])
    result
  end
  private_class_method :_merge

  # ヒープソート（in-place）
  def self.heap_sort(a)
    n = a.length

    down_heap = lambda do |arr, left, right|
      temp = arr[left]
      parent = left
      while parent < (right + 1) / 2
        cl = parent * 2 + 1
        cr = cl + 1
        child = (cr <= right && arr[cr] > arr[cl]) ? cr : cl
        break if temp >= arr[child]

        arr[parent] = arr[child]
        parent = child
      end
      arr[parent] = temp
    end

    ((n - 1) / 2).downto(0) { |i| down_heap.call(a, i, n - 1) }
    (n - 1).downto(1) do |i|
      a[0], a[i] = a[i], a[0]
      down_heap.call(a, 0, i - 1)
    end
  end

  # バブルソート第3版（走査範囲の限定）
  def self.bubble_sort3(a)
    n = a.length
    k = 0
    while k < n - 1
      last = n - 1
      (n - 1).downto(k + 1) do |j|
        if a[j - 1] > a[j]
          a[j - 1], a[j] = a[j], a[j - 1]
          last = j
        end
      end
      k = last
    end
  end

  # シェーカーソート（双方向バブルソート）
  def self.shaker_sort(a)
    left = 0
    right = a.length - 1
    last = right
    while left < right
      right.downto(left + 1) do |j|
        if a[j - 1] > a[j]
          a[j - 1], a[j] = a[j], a[j - 1]
          last = j
        end
      end
      left = last

      (left...right).each do |j|
        if a[j] > a[j + 1]
          a[j], a[j + 1] = a[j + 1], a[j]
          last = j
        end
      end
      right = last
    end
  end

  # 二分挿入ソート
  def self.binary_insertion_sort(a)
    n = a.length
    (1...n).each do |i|
      key = a[i]
      pl = 0
      pr = i - 1

      loop do
        pc = (pl + pr) / 2
        if a[pc] == key
          break
        elsif a[pc] < key
          pl = pc + 1
        else
          pr = pc - 1
        end
        break if pl > pr
      end

      pd = pl <= pr ? pc + 1 : pr + 1

      i.downto(pd + 1) { |j| a[j] = a[j - 1] }
      a[pd] = key
    end
  end

  # 非再帰的クイックソート（スタック使用）
  def self.qsort_stack(a, left = 0, right = nil)
    right ||= a.length - 1
    stack = [[left, right]]

    while stack.any?
      left, right = stack.pop
      pl = left
      pr = right
      x = a[(left + right) / 2]

      while pl <= pr
        pl += 1 while a[pl] < x
        pr -= 1 while a[pr] > x
        if pl <= pr
          a[pl], a[pr] = a[pr], a[pl]
          pl += 1
          pr -= 1
        end
      end

      stack << [left, pr] if left < pr
      stack << [pl, right] if pl < right
    end
  end

  # ソート済み配列のマージ（a と b をマージして c に格納）
  def self.merge_sorted_array(a, b, c)
    pa = pb = pc = 0
    na = a.length
    nb = b.length

    while pa < na && pb < nb
      if a[pa] <= b[pb]
        c[pc] = a[pa]
        pa += 1
      else
        c[pc] = b[pb]
        pb += 1
      end
      pc += 1
    end

    while pa < na
      c[pc] = a[pa]
      pa += 1
      pc += 1
    end

    while pb < nb
      c[pc] = b[pb]
      pb += 1
      pc += 1
    end
  end

  # 度数ソート（計数ソート）— 新しい配列を返す
  def self.counting_sort(a)
    return [] if a.empty?

    max_val = a.max
    freq = Array.new(max_val + 1, 0)
    a.each { |x| freq[x] += 1 }
    (1...freq.length).each { |i| freq[i] += freq[i - 1] }

    result = Array.new(a.length, 0)
    a.reverse_each do |x|
      freq[x] -= 1
      result[freq[x]] = x
    end
    result
  end
end
