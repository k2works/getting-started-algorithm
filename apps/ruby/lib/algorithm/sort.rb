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
