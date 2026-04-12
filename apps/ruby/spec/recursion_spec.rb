# frozen_string_literal: true

require "set"
require "algorithm/recursion"

RSpec.describe "第5章 再帰アルゴリズム" do
  describe "Algorithm.factorial" do
    it "5の階乗" do
      expect(Algorithm.factorial(5)).to eq(120)
    end

    it "0の階乗" do
      expect(Algorithm.factorial(0)).to eq(1)
    end
  end

  describe "Algorithm.gcd" do
    it "22と8の最大公約数" do
      expect(Algorithm.gcd(22, 8)).to eq(2)
    end

    it "48と18の最大公約数" do
      expect(Algorithm.gcd(48, 18)).to eq(6)
    end
  end

  describe "Algorithm.recursive_sum" do
    it "1から5までの和" do
      expect(Algorithm.recursive_sum(5)).to eq(15)
    end
  end

  describe "Algorithm.hanoi" do
    it "円盤1枚のハノイ" do
      expect(Algorithm.hanoi(1, "A", "C", "B")).to eq([["A", "C"]])
    end

    it "円盤3枚のハノイの手順数" do
      expect(Algorithm.hanoi(3, "A", "C", "B").length).to eq(7)
    end
  end

  describe "Algorithm.maze_solve" do
    it "解あり迷路" do
      maze = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]
      expect(Algorithm.maze_solve(maze, 1, 1, 1, 1)).to be true
    end

    it "スタート=ゴールは常に解あり" do
      maze = [[0, 0], [0, 0]]
      expect(Algorithm.maze_solve(maze, 0, 0, 0, 0)).to be true
    end
  end

  describe "Algorithm::EightQueen" do
    it "全組み合わせは 8^8 = 16777216 通り" do
      q = Algorithm::EightQueen.new
      q.set(0)
      expect(q.result.length).to eq(8**8)
    end
  end

  describe "Algorithm::EightQueen2" do
    it "行制約あり: 8! = 40320 通り" do
      q = Algorithm::EightQueen2.new
      q.set(0)
      expect(q.result.length).to eq(40320)
    end
  end

  describe "Algorithm::EightQueen3" do
    it "完全な8王妃問題: 92 通り" do
      q = Algorithm::EightQueen3.new
      q.set(0)
      expect(q.result.length).to eq(92)
    end
  end

  describe "Algorithm.recure" do
    it "真に再帰的な関数: recure(4, []) => [1, 2, 3, 1, 4, 1, 2]" do
      expect(Algorithm.recure(4, [])).to eq([1, 2, 3, 1, 4, 1, 2])
    end

    it "n=0 のとき空リスト" do
      expect(Algorithm.recure(0, [])).to eq([])
    end
  end

  describe "Algorithm.recure2" do
    it "末尾再帰除去版: recure2(4, []) => [1, 2, 3, 1, 4, 1, 2]" do
      expect(Algorithm.recure2(4, [])).to eq([1, 2, 3, 1, 4, 1, 2])
    end
  end
end
