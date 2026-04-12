namespace Algorithm;

/// <summary>第2章 配列</summary>
public static class ArrayAlgorithms
{
    public static int MaxOf(int[] a)
    {
        int maximum = a[0];
        for (int i = 1; i < a.Length; i++)
            if (a[i] > maximum) maximum = a[i];
        return maximum;
    }

    public static void Reverse(int[] a)
    {
        int n = a.Length;
        for (int i = 0; i < n / 2; i++)
            (a[i], a[n - i - 1]) = (a[n - i - 1], a[i]);
    }

    public static string CardConv(int x, int r)
    {
        const string dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var d = new System.Text.StringBuilder();
        while (x > 0) { d.Append(dchar[x % r]); x /= r; }
        var arr = d.ToString().ToCharArray();
        System.Array.Reverse(arr);
        return new string(arr);
    }

    public static int Prime1(int x)
    {
        int counter = 0;
        for (int n = 2; n <= x; n++)
            for (int i = 2; i < n; i++) { counter++; if (n % i == 0) break; }
        return counter;
    }

    public static int Prime2(int x)
    {
        int counter = 0, ptr = 0;
        int[] prime = new int[500];
        prime[ptr++] = 2;
        for (int n = 3; n <= x; n += 2)
        {
            bool found = false;
            for (int i = 1; i < ptr; i++) { counter++; if (n % prime[i] == 0) { found = true; break; } }
            if (!found) prime[ptr++] = n;
        }
        return counter;
    }

    public static int Prime3(int x)
    {
        int counter = 0, ptr = 0;
        int[] prime = new int[500];
        prime[ptr++] = 2; prime[ptr++] = 3;
        for (int n = 5; n <= 1000; n += 2)
        {
            bool isPrime = true;
            int i = 1;
            while (prime[i] * prime[i] <= n)
            {
                counter += 2;
                if (n % prime[i] == 0) { isPrime = false; break; }
                i++;
            }
            if (isPrime) { prime[ptr++] = n; counter++; }
        }
        return counter;
    }
}
