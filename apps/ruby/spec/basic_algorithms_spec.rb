# frozen_string_literal: true

require "algorithm/basic_algorithms"

RSpec.describe "第1章 基本的なアルゴリズム" do
  describe "Algorithm.max3" do
    subject { Algorithm.max3(a, b, c) }

    [
      [3, 2, 1, 3],
      [3, 2, 2, 3],
      [3, 1, 2, 3],
      [3, 2, 3, 3],
      [2, 1, 3, 3],
      [3, 3, 2, 3],
      [3, 3, 3, 3],
      [2, 2, 3, 3],
      [2, 3, 1, 3],
      [2, 3, 2, 3],
      [1, 3, 2, 3],
      [2, 3, 3, 3],
      [1, 2, 3, 3]
    ].each do |a_val, b_val, c_val, expected|
      context "max3(#{a_val}, #{b_val}, #{c_val})" do
        let(:a) { a_val }
        let(:b) { b_val }
        let(:c) { c_val }

        it { is_expected.to eq(expected) }
      end
    end
  end

  describe "Algorithm.med3" do
    [
      [3, 2, 1, 2],
      [3, 2, 2, 2],
      [3, 1, 2, 2],
      [3, 2, 3, 3],
      [2, 1, 3, 2],
      [3, 3, 2, 3],
      [3, 3, 3, 3],
      [2, 2, 3, 2],
      [2, 3, 1, 2],
      [2, 3, 2, 2],
      [1, 3, 2, 2],
      [2, 3, 3, 3],
      [1, 2, 3, 2]
    ].each do |a, b, c, expected|
      it "med3(#{a}, #{b}, #{c}) == #{expected}" do
        expect(Algorithm.med3(a, b, c)).to eq(expected)
      end
    end
  end

  describe "Algorithm.judge_sign" do
    it "正の値" do
      expect(Algorithm.judge_sign(17)).to eq("その値は正です。")
    end

    it "負の値" do
      expect(Algorithm.judge_sign(-5)).to eq("その値は負です。")
    end

    it "0" do
      expect(Algorithm.judge_sign(0)).to eq("その値は0です。")
    end
  end

  describe "繰り返し処理 — 1からnまでの総和" do
    it "while ループで合計を求める" do
      expect(Algorithm.sum_1_to_n_while(5)).to eq(15)
    end

    it "for ループで合計を求める" do
      expect(Algorithm.sum_1_to_n_for(5)).to eq(15)
    end
  end

  describe "繰り返し処理 — 記号文字の交互表示" do
    it "alternative_1 で偶数個" do
      expect(Algorithm.alternative_1(12)).to eq("+-+-+-+-+-+-")
    end

    it "alternative_2 で偶数個" do
      expect(Algorithm.alternative_2(12)).to eq("+-+-+-+-+-+-")
    end

    it "alternative_1 で奇数個" do
      expect(Algorithm.alternative_1(5)).to eq("+-+-+")
    end

    it "alternative_2 で奇数個" do
      expect(Algorithm.alternative_2(5)).to eq("+-+-+")
    end
  end

  describe "Algorithm.rectangle" do
    it "面積32の長方形の辺の組み合わせ" do
      expect(Algorithm.rectangle(32)).to eq("1x32 2x16 4x8 ")
    end
  end

  describe "Algorithm.multiplication_table" do
    it "九九の表" do
      expected = [
        "---------------------------",
        "  1  2  3  4  5  6  7  8  9",
        "  2  4  6  8 10 12 14 16 18",
        "  3  6  9 12 15 18 21 24 27",
        "  4  8 12 16 20 24 28 32 36",
        "  5 10 15 20 25 30 35 40 45",
        "  6 12 18 24 30 36 42 48 54",
        "  7 14 21 28 35 42 49 56 63",
        "  8 16 24 32 40 48 56 64 72",
        "  9 18 27 36 45 54 63 72 81",
        "---------------------------"
      ].join("\n")
      expect(Algorithm.multiplication_table).to eq(expected)
    end
  end

  describe "Algorithm.traiangle_lb" do
    it "左下直角の二等辺三角形" do
      expect(Algorithm.traiangle_lb(5)).to eq("*\n**\n***\n****\n*****\n")
    end
  end
end
