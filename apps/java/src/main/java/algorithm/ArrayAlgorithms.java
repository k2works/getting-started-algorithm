package algorithm;

/** 第2章 配列 */
public class ArrayAlgorithms {

    /** 配列の要素の最大値を返す */
    public static int maxOf(int[] a) {
        int maximum = a[0];
        for (int i = 1; i < a.length; i++) {
            if (a[i] > maximum) maximum = a[i];
        }
        return maximum;
    }

    /** 配列の要素の並びを反転する */
    public static void reverse(int[] a) {
        int n = a.length;
        for (int i = 0; i < n / 2; i++) {
            int tmp = a[i];
            a[i] = a[n - i - 1];
            a[n - i - 1] = tmp;
        }
    }

    /** 整数値 x を r 進数に変換した文字列を返す */
    public static String cardConv(int x, int r) {
        String dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        StringBuilder d = new StringBuilder();
        while (x > 0) {
            d.append(dchar.charAt(x % r));
            x /= r;
        }
        return d.reverse().toString();
    }

    /** x 以下の素数を列挙する（第1版）-- 除算回数を返す */
    public static int prime1(int x) {
        int counter = 0;
        for (int n = 2; n <= x; n++) {
            for (int i = 2; i < n; i++) {
                counter++;
                if (n % i == 0) break;
            }
        }
        return counter;
    }

    /** x 以下の素数を列挙する（第2版）-- 除算回数を返す */
    public static int prime2(int x) {
        int counter = 0;
        int ptr = 0;
        int[] prime = new int[500];
        prime[ptr++] = 2;

        outer:
        for (int n = 3; n <= x; n += 2) {
            for (int i = 1; i < ptr; i++) {
                counter++;
                if (n % prime[i] == 0) continue outer;
            }
            prime[ptr++] = n;
        }
        return counter;
    }

    /** x 以下の素数を列挙する（第3版）-- 除算回数を返す */
    public static int prime3(int x) {
        int counter = 0;
        int ptr = 0;
        int[] prime = new int[500];
        prime[ptr++] = 2;
        prime[ptr++] = 3;

        for (int n = 5; n <= 1000; n += 2) {
            boolean isPrime = true;
            int i = 1;
            while (prime[i] * prime[i] <= n) {
                counter += 2;
                if (n % prime[i] == 0) {
                    isPrime = false;
                    break;
                }
                i++;
            }
            if (isPrime) {
                prime[ptr++] = n;
                counter++;
            }
        }
        return counter;
    }
}
