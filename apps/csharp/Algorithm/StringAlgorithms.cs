namespace Algorithm;

/// <summary>第7章 文字列処理</summary>
public static class StringAlgorithms
{
    public static int BfMatch(string txt, string pat)
    {
        int n = txt.Length, m = pat.Length;
        if (m == 0) return 0;
        for (int i = 0; i <= n - m; i++)
        {
            int j = 0;
            while (j < m && txt[i + j] == pat[j]) j++;
            if (j == m) return i;
        }
        return -1;
    }

    public static int KmpMatch(string txt, string pat)
    {
        int n = txt.Length, m = pat.Length;
        if (m == 0) return 0;
        int[] table = BuildKmpTable(pat);
        int j = 0;
        for (int i = 0; i < n; i++)
        {
            while (j > 0 && txt[i] != pat[j]) j = table[j - 1];
            if (txt[i] == pat[j]) j++;
            if (j == m) return i - m + 1;
        }
        return -1;
    }

    private static int[] BuildKmpTable(string pat)
    {
        int m = pat.Length;
        int[] table = new int[m];
        int k = 0;
        for (int i = 1; i < m; i++)
        {
            while (k > 0 && pat[k] != pat[i]) k = table[k - 1];
            if (pat[k] == pat[i]) k++;
            table[i] = k;
        }
        return table;
    }

    public static int BmMatch(string txt, string pat)
    {
        int n = txt.Length, m = pat.Length;
        if (m == 0) return 0;
        var badChar = new Dictionary<char, int>();
        for (int i = 0; i < m; i++) badChar[pat[i]] = i;
        int s = 0;
        while (s <= n - m)
        {
            int j = m - 1;
            while (j >= 0 && pat[j] == txt[s + j]) j--;
            if (j < 0) return s;
            int skip = j - (badChar.TryGetValue(txt[s + j], out int bc) ? bc : -1);
            s += Math.Max(1, skip);
        }
        return -1;
    }

    public static Dictionary<char, int> CountChars(string s)
    {
        var result = new Dictionary<char, int>();
        foreach (char c in s)
        {
            result.TryGetValue(c, out int count);
            result[c] = count + 1;
        }
        return result;
    }

    public static string ReverseString(string s)
    {
        var arr = s.ToCharArray();
        System.Array.Reverse(arr);
        return new string(arr);
    }

    public static bool IsPalindrome(string s) => s == ReverseString(s);
}
