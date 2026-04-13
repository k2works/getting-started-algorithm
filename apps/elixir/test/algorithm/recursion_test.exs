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
  end

  describe "hanoi/3" do
    test "ハノイの塔の手順リストを返す" do
      result = Recursion.hanoi(3, "A", "C")
      assert length(result) == 7
    end
  end

  describe "eight_queens/0" do
    test "8 クイーン問題の解が 92 通りある" do
      solutions = Recursion.eight_queens()
      assert length(solutions) == 92
    end
  end
end
