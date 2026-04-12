# frozen_string_literal: true

require "algorithm/strings"

RSpec.describe "第7章 文字列処理" do
  let(:text) { "ABCXDEZCABACABAB" }
  let(:pattern) { "ABAB" }

  describe "Algorithm.bf_match" do
    it "パターンが見つかる" do
      expect(Algorithm.bf_match(text, pattern)).to eq(12)
    end

    it "パターンが見つからない" do
      expect(Algorithm.bf_match("AAAA", "BB")).to eq(-1)
    end

    it "空パターンは位置0を返す" do
      expect(Algorithm.bf_match("hello", "")).to eq(0)
    end
  end

  describe "Algorithm.kmp_match" do
    it "パターンが見つかる" do
      expect(Algorithm.kmp_match(text, pattern)).to eq(12)
    end

    it "パターンが見つからない" do
      expect(Algorithm.kmp_match("AAAA", "BB")).to eq(-1)
    end

    it "空パターンは位置0を返す" do
      expect(Algorithm.kmp_match("hello", "")).to eq(0)
    end
  end

  describe "Algorithm.bm_match" do
    it "パターンが見つかる" do
      expect(Algorithm.bm_match(text, pattern)).to eq(12)
    end

    it "パターンが見つからない" do
      expect(Algorithm.bm_match("AAAA", "BB")).to eq(-1)
    end

    it "空パターンは位置0を返す" do
      expect(Algorithm.bm_match("hello", "")).to eq(0)
    end
  end

  describe "Algorithm.count_chars" do
    it "文字の出現回数を返す" do
      expect(Algorithm.count_chars("hello")).to eq({ "h" => 1, "e" => 1, "l" => 2, "o" => 1 })
    end
  end

  describe "Algorithm.reverse_string" do
    it "文字列を逆順にする" do
      expect(Algorithm.reverse_string("hello")).to eq("olleh")
    end
  end

  describe "Algorithm.palindrome?" do
    it "回文を判定する（真）" do
      expect(Algorithm.palindrome?("racecar")).to be true
    end

    it "回文を判定する（偽）" do
      expect(Algorithm.palindrome?("hello")).to be false
    end
  end
end
