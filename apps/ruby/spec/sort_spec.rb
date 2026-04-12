# frozen_string_literal: true

require "algorithm/sort"

RSpec.describe "第6章 ソートアルゴリズム" do
  let(:unsorted) { [6, 4, 3, 7, 1, 9, 8] }
  let(:sorted) { [1, 3, 4, 6, 7, 8, 9] }

  describe "Algorithm.bubble_sort" do
    it "バブルソート（in-place）" do
      a = unsorted.dup
      Algorithm.bubble_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.selection_sort" do
    it "選択ソート（in-place）" do
      a = unsorted.dup
      Algorithm.selection_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.insertion_sort" do
    it "挿入ソート（in-place）" do
      a = unsorted.dup
      Algorithm.insertion_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.shell_sort" do
    it "シェルソート（in-place）" do
      a = unsorted.dup
      Algorithm.shell_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.quick_sort" do
    it "クイックソート（in-place）" do
      a = unsorted.dup
      Algorithm.quick_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.merge_sort" do
    it "マージソート（新しい配列）" do
      expect(Algorithm.merge_sort(unsorted)).to eq(sorted)
    end
  end

  describe "Algorithm.heap_sort" do
    it "ヒープソート（in-place）" do
      a = unsorted.dup
      Algorithm.heap_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.counting_sort" do
    it "度数ソート（計数ソート、新しい配列）" do
      expect(Algorithm.counting_sort(unsorted)).to eq(sorted)
    end

    it "空配列" do
      expect(Algorithm.counting_sort([])).to eq([])
    end
  end

  describe "Algorithm.bubble_sort3" do
    it "バブルソート（走査範囲の限定）" do
      a = unsorted.dup
      Algorithm.bubble_sort3(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.shaker_sort" do
    it "シェーカーソート（双方向バブルソート）" do
      a = unsorted.dup
      Algorithm.shaker_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.binary_insertion_sort" do
    it "二分挿入ソート" do
      a = unsorted.dup
      Algorithm.binary_insertion_sort(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.qsort_stack" do
    it "非再帰的クイックソート" do
      a = unsorted.dup
      Algorithm.qsort_stack(a)
      expect(a).to eq(sorted)
    end
  end

  describe "Algorithm.merge_sorted_array" do
    it "ソート済み配列のマージ" do
      a = [1, 3, 5, 7]
      b = [2, 4, 6, 8]
      c = Array.new(8)
      Algorithm.merge_sorted_array(a, b, c)
      expect(c).to eq([1, 2, 3, 4, 5, 6, 7, 8])
    end
  end
end
