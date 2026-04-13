defmodule Algorithm.BasicAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.BasicAlgorithms

  describe "max3/3" do
    test "3 つの値のうち最大値を返す" do
      assert BasicAlgorithms.max3(3, 2, 1) == 3
      assert BasicAlgorithms.max3(1, 2, 3) == 3
      assert BasicAlgorithms.max3(3, 3, 2) == 3
    end
  end

  describe "mid3/3" do
    test "3 つの値のうち中央値を返す" do
      assert BasicAlgorithms.mid3(3, 2, 1) == 2
      assert BasicAlgorithms.mid3(1, 2, 3) == 2
      assert BasicAlgorithms.mid3(1, 1, 3) == 1
    end
  end
end
