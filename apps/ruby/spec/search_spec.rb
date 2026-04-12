# frozen_string_literal: true

require "algorithm/search"

RSpec.describe "第3章 探索アルゴリズム" do
  let(:arr) { [6, 4, 3, 2, 1, 2, 8] }

  describe "線形探索" do
    it "ssearch_while: キーが見つかる" do
      expect(Algorithm.ssearch_while(arr, 2)).to eq(3)
    end

    it "ssearch_while: キーが見つからない" do
      expect(Algorithm.ssearch_while(arr, 99)).to eq(-1)
    end

    it "ssearch_for: キーが見つかる" do
      expect(Algorithm.ssearch_for(arr, 2)).to eq(3)
    end

    it "ssearch_for: キーが見つからない" do
      expect(Algorithm.ssearch_for(arr, 99)).to eq(-1)
    end

    it "ssearch_sentinel: キーが見つかる" do
      expect(Algorithm.ssearch_sentinel(arr, 2)).to eq(3)
    end

    it "ssearch_sentinel: キーが見つからない" do
      expect(Algorithm.ssearch_sentinel(arr, 99)).to eq(-1)
    end
  end

  describe "二分探索" do
    let(:sorted) { [1, 2, 3, 5, 7, 8, 9] }

    it "キーが見つかる" do
      expect(Algorithm.bseach(sorted, 5)).to eq(3)
    end

    it "キーが見つからない" do
      expect(Algorithm.bseach(sorted, 4)).to eq(-1)
    end
  end

  describe "Algorithm::ChainedHash" do
    let(:hash) { Algorithm::ChainedHash.new(13) }

    it "追加と探索ができる" do
      hash.add("Alice", 1)
      hash.add("Bob", 2)
      expect(hash.search("Alice")).to eq(1)
      expect(hash.search("Bob")).to eq(2)
    end

    it "重複追加は失敗する" do
      hash.add("Alice", 1)
      expect(hash.add("Alice", 2)).to be false
    end

    it "削除できる" do
      hash.add("Alice", 1)
      hash.remove("Alice")
      expect(hash.search("Alice")).to be nil
    end
  end

  describe "Algorithm::OpenHash" do
    let(:hash) { Algorithm::OpenHash.new(13) }

    it "追加と探索ができる" do
      hash.add("Alice", 1)
      hash.add("Bob", 2)
      expect(hash.search("Alice")).to eq(1)
      expect(hash.search("Bob")).to eq(2)
    end

    it "重複追加は失敗する" do
      hash.add("Alice", 1)
      expect(hash.add("Alice", 2)).to be false
    end

    it "削除できる" do
      hash.add("Alice", 1)
      hash.remove("Alice")
      expect(hash.search("Alice")).to be nil
    end
  end
end
