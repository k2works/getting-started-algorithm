defmodule Algorithm.StringsTest do
  use ExUnit.Case
  alias Algorithm.Strings

  describe "brute_force_search/2" do
    test "文字列内のパターンを検索する" do
      assert Strings.brute_force_search("ABCABC", "CAB") == {:ok, 2}
    end

    test "パターンが見つからない場合 :not_found を返す" do
      assert Strings.brute_force_search("ABCABC", "XYZ") == :not_found
    end
  end

  describe "kmp_search/2" do
    test "KMP 法で文字列を検索する" do
      assert Strings.kmp_search("ABCABC", "CAB") == {:ok, 2}
    end

    test "パターンが見つからない場合 :not_found を返す" do
      assert Strings.kmp_search("ABCABC", "XYZ") == :not_found
    end
  end

  describe "bm_search/2" do
    test "BM 法で文字列を検索する" do
      assert Strings.bm_search("ABCABC", "CAB") == {:ok, 2}
    end

    test "パターンが見つからない場合 :not_found を返す" do
      assert Strings.bm_search("ABCABC", "XYZ") == :not_found
    end

    test "先頭のパターンを見つける" do
      assert Strings.bm_search("ABCDEF", "ABC") == {:ok, 0}
    end
  end

  describe "char_count/1" do
    test "各文字の出現回数を返す" do
      assert Strings.char_count("hello") == %{"h" => 1, "e" => 1, "l" => 2, "o" => 1}
    end
  end

  describe "reverse_string/1" do
    test "文字列を逆順にする" do
      assert Strings.reverse_string("hello") == "olleh"
    end
  end

  describe "palindrome?/1" do
    test "回文の場合 true を返す" do
      assert Strings.palindrome?("racecar") == true
    end

    test "回文でない場合 false を返す" do
      assert Strings.palindrome?("hello") == false
    end
  end
end
