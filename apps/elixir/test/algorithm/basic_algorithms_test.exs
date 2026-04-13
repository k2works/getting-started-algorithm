defmodule Algorithm.BasicAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.BasicAlgorithms

  describe "max3/3" do
    test "3 つの値のうち最大値を返す（全 13 パターン）" do
      cases = [
        {3, 2, 1, 3},
        {3, 2, 2, 3},
        {3, 1, 2, 3},
        {3, 2, 3, 3},
        {2, 1, 3, 3},
        {3, 3, 2, 3},
        {3, 3, 3, 3},
        {2, 2, 3, 3},
        {2, 3, 1, 3},
        {2, 3, 2, 3},
        {1, 3, 2, 3},
        {2, 3, 3, 3},
        {1, 2, 3, 3}
      ]

      for {a, b, c, expected} <- cases do
        assert BasicAlgorithms.max3(a, b, c) == expected,
               "max3(#{a}, #{b}, #{c}) should be #{expected}"
      end
    end
  end

  describe "mid3/3" do
    test "3 つの値のうち中央値を返す（全 13 パターン）" do
      cases = [
        {3, 2, 1, 2},
        {3, 2, 2, 2},
        {3, 1, 2, 2},
        {3, 2, 3, 3},
        {2, 1, 3, 2},
        {3, 3, 2, 3},
        {3, 3, 3, 3},
        {2, 2, 3, 2},
        {2, 3, 1, 2},
        {2, 3, 2, 2},
        {1, 3, 2, 2},
        {2, 3, 3, 3},
        {1, 2, 3, 2}
      ]

      for {a, b, c, expected} <- cases do
        assert BasicAlgorithms.mid3(a, b, c) == expected,
               "mid3(#{a}, #{b}, #{c}) should be #{expected}"
      end
    end
  end

  describe "judge_sign/1" do
    test "正の値" do
      assert BasicAlgorithms.judge_sign(17) == "その値は正です。"
    end

    test "負の値" do
      assert BasicAlgorithms.judge_sign(-5) == "その値は負です。"
    end

    test "ゼロ" do
      assert BasicAlgorithms.judge_sign(0) == "その値は0です。"
    end
  end

  describe "sum_1_to_n/1" do
    test "再帰で 1 から n までの総和を返す" do
      assert BasicAlgorithms.sum_1_to_n(5) == 15
      assert BasicAlgorithms.sum_1_to_n(1) == 1
      assert BasicAlgorithms.sum_1_to_n(10) == 55
    end
  end

  describe "sum_1_to_n_enum/1" do
    test "Enum で 1 から n までの総和を返す" do
      assert BasicAlgorithms.sum_1_to_n_enum(5) == 15
      assert BasicAlgorithms.sum_1_to_n_enum(1) == 1
      assert BasicAlgorithms.sum_1_to_n_enum(10) == 55
    end
  end

  describe "alternative/1" do
    test "偶数個の記号を交互に表示する" do
      assert BasicAlgorithms.alternative(12) == "+-+-+-+-+-+-"
    end

    test "奇数個の記号を交互に表示する" do
      assert BasicAlgorithms.alternative(5) == "+-+-+"
    end
  end

  describe "rectangle/1" do
    test "面積が area の長方形の辺の長さを列挙する" do
      assert BasicAlgorithms.rectangle(32) == "1x32 2x16 4x8 "
    end
  end

  describe "multiplication_table/0" do
    test "九九の表を返す" do
      expected =
        "---------------------------\n" <>
          "  1  2  3  4  5  6  7  8  9\n" <>
          "  2  4  6  8 10 12 14 16 18\n" <>
          "  3  6  9 12 15 18 21 24 27\n" <>
          "  4  8 12 16 20 24 28 32 36\n" <>
          "  5 10 15 20 25 30 35 40 45\n" <>
          "  6 12 18 24 30 36 42 48 54\n" <>
          "  7 14 21 28 35 42 49 56 63\n" <>
          "  8 16 24 32 40 48 56 64 72\n" <>
          "  9 18 27 36 45 54 63 72 81\n" <>
          "---------------------------"

      assert BasicAlgorithms.multiplication_table() == expected
    end
  end

  describe "triangle_lb/1" do
    test "左下側が直角の二等辺三角形を返す" do
      expected = "*\n**\n***\n****\n*****\n"
      assert BasicAlgorithms.triangle_lb(5) == expected
    end
  end
end
