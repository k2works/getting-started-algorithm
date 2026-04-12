# frozen_string_literal: true

require "algorithm/arrays"

RSpec.describe "第2章 配列" do
  describe "Algorithm.max_of" do
    it "配列の最大値を返す" do
      expect(Algorithm.max_of([172, 153, 192, 140, 165])).to eq(192)
    end
  end

  describe "Algorithm.reverse_array" do
    it "配列を逆順にする（破壊的）" do
      a = [2, 5, 1, 3, 9, 6, 7]
      Algorithm.reverse_array(a)
      expect(a).to eq([7, 6, 9, 3, 1, 5, 2])
    end
  end

  describe "Algorithm.card_conv" do
    it "2進数変換" do
      expect(Algorithm.card_conv(29, 2)).to eq("11101")
    end

    it "16進数変換" do
      expect(Algorithm.card_conv(255, 16)).to eq("FF")
    end
  end

  describe "素数列挙" do
    it "prime1: 1000以下の素数の除算回数" do
      expect(Algorithm.prime1(1000)).to eq(78022)
    end

    it "prime2: 1000以下の素数の除算回数（最適化版）" do
      expect(Algorithm.prime2(1000)).to eq(14622)
    end

    it "prime3: 1000以下の素数の除算回数（平方根最適化版）" do
      expect(Algorithm.prime3(1000)).to eq(3774)
    end
  end
end
