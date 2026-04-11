package algorithm;

import java.util.HashMap;
import java.util.Map;

/** 第7章 文字列処理 */
public class StringAlgorithms {

    /** ブルートフォース文字列探索 */
    public static int bfMatch(String txt, String pat) {
        int n = txt.length();
        int m = pat.length();
        if (m == 0) return 0;
        for (int i = 0; i <= n - m; i++) {
            int j = 0;
            while (j < m && txt.charAt(i + j) == pat.charAt(j)) j++;
            if (j == m) return i;
        }
        return -1;
    }

    /** KMP 文字列探索 */
    public static int kmpMatch(String txt, String pat) {
        int n = txt.length();
        int m = pat.length();
        if (m == 0) return 0;
        int[] table = buildKmpTable(pat);
        int j = 0;
        for (int i = 0; i < n; i++) {
            while (j > 0 && txt.charAt(i) != pat.charAt(j)) j = table[j - 1];
            if (txt.charAt(i) == pat.charAt(j)) j++;
            if (j == m) return i - m + 1;
        }
        return -1;
    }

    private static int[] buildKmpTable(String pat) {
        int m = pat.length();
        int[] table = new int[m];
        int k = 0;
        for (int i = 1; i < m; i++) {
            while (k > 0 && pat.charAt(k) != pat.charAt(i)) k = table[k - 1];
            if (pat.charAt(k) == pat.charAt(i)) k++;
            table[i] = k;
        }
        return table;
    }

    /** Boyer-Moore 文字列探索（Bad Character ルールのみ） */
    public static int bmMatch(String txt, String pat) {
        int n = txt.length();
        int m = pat.length();
        if (m == 0) return 0;
        Map<Character, Integer> badChar = new HashMap<>();
        for (int i = 0; i < m; i++) badChar.put(pat.charAt(i), i);
        int s = 0;
        while (s <= n - m) {
            int j = m - 1;
            while (j >= 0 && pat.charAt(j) == txt.charAt(s + j)) j--;
            if (j < 0) return s;
            int skip = j - badChar.getOrDefault(txt.charAt(s + j), -1);
            s += Math.max(1, skip);
        }
        return -1;
    }

    /** 文字列中の各文字の出現回数を返す */
    public static Map<Character, Integer> countChars(String s) {
        Map<Character, Integer> result = new HashMap<>();
        for (char c : s.toCharArray()) {
            result.merge(c, 1, Integer::sum);
        }
        return result;
    }

    /** 文字列を逆順にして返す */
    public static String reverseString(String s) {
        return new StringBuilder(s).reverse().toString();
    }

    /** 文字列が回文かどうかを判定 */
    public static boolean isPalindrome(String s) {
        return s.equals(new StringBuilder(s).reverse().toString());
    }
}
