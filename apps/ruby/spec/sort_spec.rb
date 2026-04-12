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
end
