namespace Algorithm;

/// <summary>第1章 基本的なアルゴリズム</summary>
public static class BasicAlgorithms
{
    /// <summary>3つの整数値の最大値を返す</summary>
    public static int Max3(int a, int b, int c)
    {
        int maximum = a;
        if (b > maximum) maximum = b;
        if (c > maximum) maximum = c;
        return maximum;
    }

    /// <summary>3つの整数値の中央値を返す</summary>
    public static int Med3(int a, int b, int c)
    {
        if (a >= b)
        {
            if (b >= c) return b;
            else if (a <= c) return a;
            else return c;
        }
        else if (a > c) return a;
        else if (b > c) return c;
        else return b;
    }

    /// <summary>整数値の符号を判定する</summary>
    public static string JudgeSign(int n)
    {
        if (n > 0) return "その値は正です。";
        else if (n < 0) return "その値は負です。";
        else return "その値は0です。";
    }

    /// <summary>while 文で 1 から n までの総和を求める</summary>
    public static int Sum1ToNWhile(int n)
    {
        int total = 0, i = 1;
        while (i <= n) { total += i; i++; }
        return total;
    }

    /// <summary>for 文で 1 から n までの総和を求める</summary>
    public static int Sum1ToNFor(int n)
    {
        int total = 0;
        for (int i = 1; i <= n; i++) total += i;
        return total;
    }

    /// <summary>記号文字 '+' と '-' を交互に表示する（剰余判定方式）</summary>
    public static string Alternative1(int n)
    {
        var sb = new System.Text.StringBuilder();
        for (int i = 0; i < n; i++) sb.Append(i % 2 != 0 ? '-' : '+');
        return sb.ToString();
    }

    /// <summary>記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式）</summary>
    public static string Alternative2(int n)
    {
        var sb = new System.Text.StringBuilder();
        for (int i = 0; i < n / 2; i++) sb.Append("+-");
        if (n % 2 != 0) sb.Append('+');
        return sb.ToString();
    }

    /// <summary>縦横が整数で面積が area の長方形の辺の長さを列挙する</summary>
    public static string Rectangle(int area)
    {
        var sb = new System.Text.StringBuilder();
        for (int i = 1; i <= area; i++)
        {
            if ((long)i * i > area) break;
            if (area % i != 0) continue;
            sb.Append($"{i}x{area / i} ");
        }
        return sb.ToString();
    }

    /// <summary>九九の表を返す</summary>
    public static string MultiplicationTable()
    {
        var sb = new System.Text.StringBuilder();
        sb.AppendLine(new string('-', 27));
        for (int i = 1; i <= 9; i++)
        {
            for (int j = 1; j <= 9; j++) sb.Append($"{i * j,3}");
            sb.AppendLine();
        }
        sb.Append(new string('-', 27));
        return sb.ToString();
    }

    /// <summary>左下側が直角の二等辺三角形を返す</summary>
    public static string TriangleLb(int n)
    {
        var sb = new System.Text.StringBuilder();
        for (int i = 0; i < n; i++) sb.AppendLine(new string('*', i + 1));
        return sb.ToString();
    }
}
