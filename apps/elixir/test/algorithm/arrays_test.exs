defmodule Algorithm.ArraysTest do
  use ExUnit.Case
  alias Algorithm.Arrays

  describe "max_of_list/1" do
    test "リストの最大値を返す" do
      assert Arrays.max_of_list([3, 1, 4, 1, 5, 9, 2, 6]) == 9
    end
  end

  describe "cardinal_number/2" do
    test "10 進数を指定の基数に変換した文字列を返す" do
      assert Arrays.cardinal_number(29, 2) == "11101"
      assert Arrays.cardinal_number(59, 16) == "3B"
    end
  end

  describe "prime_numbers/1" do
    test "n 以下の素数リストを返す" do
      assert Arrays.prime_numbers(20) == [2, 3, 5, 7, 11, 13, 17, 19]
    end
  end
end
