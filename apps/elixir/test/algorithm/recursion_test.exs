defmodule Algorithm.RecursionTest do
  use ExUnit.Case
  alias Algorithm.Recursion

  describe "factorial/1" do
    test "0 の階乗は 1" do
      assert Recursion.factorial(0) == 1
    end

    test "5 の階乗は 120" do
      assert Recursion.factorial(5) == 120
    end
  end

  describe "gcd/2" do
    test "最大公約数を求める" do
      assert Recursion.gcd(22, 8) == 2
      assert Recursion.gcd(15, 10) == 5
    end

    test "互いに素な場合は 1" do
      assert Recursion.gcd(7, 11) == 1
    end
  end

  describe "hanoi/3" do
    test "1 枚の場合は 1 手" do
      result = Recursion.hanoi(1, "A", "C")
      assert result == [{"A", "C"}]
    end

    test "n 枚の移動回数は 2^n - 1" do
      for n <- 1..5 do
        result = Recursion.hanoi(n, "A", "C")
        assert length(result) == Integer.pow(2, n) - 1
      end
    end
  end

  describe "recure/1" do
    test "真に再帰的な関数の結果を返す" do
      assert Recursion.recure(4) == [1, 2, 3, 1, 4, 1, 2]
    end
  end

  describe "maze_solve/5" do
    test "解ける迷路は true を返す" do
      maze = [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]
      ]

      assert Recursion.maze_solve(maze, {1, 1}, {3, 3}) == true
    end

    test "解けない迷路は false を返す" do
      maze = [
        [1, 1, 1, 1, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 1, 1, 1, 1]
      ]

      assert Recursion.maze_solve(maze, {1, 1}, {3, 3}) == false
    end
  end

  describe "eight_queens/0" do
    test "8 クイーン問題の解が 92 通りある" do
      solutions = Recursion.eight_queens()
      assert length(solutions) == 92
    end
  end
end
