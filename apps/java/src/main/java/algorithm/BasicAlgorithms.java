package algorithm;

/** 第1章 基本的なアルゴリズム */
public class BasicAlgorithms {

    /** 3つの整数値の最大値を返す */
    public static int max3(int a, int b, int c) {
        int maximum = a;
        if (b > maximum) maximum = b;
        if (c > maximum) maximum = c;
        return maximum;
    }

    /** 3つの整数値の中央値を返す */
    public static int med3(int a, int b, int c) {
        if (a >= b) {
            if (b >= c) return b;
            else if (a <= c) return a;
            else return c;
        } else if (a > c) {
            return a;
        } else if (b > c) {
            return c;
        } else {
            return b;
        }
    }

    /** 整数値の符号を判定する */
    public static String judgeSign(int n) {
        if (n > 0) return "その値は正です。";
        else if (n < 0) return "その値は負です。";
        else return "その値は0です。";
    }

    /** while 文で 1 から n までの総和を求める */
    public static int sum1ToNWhile(int n) {
        int total = 0;
        int i = 1;
        while (i <= n) {
            total += i;
            i++;
        }
        return total;
    }

    /** for 文で 1 から n までの総和を求める */
    public static int sum1ToNFor(int n) {
        int total = 0;
        for (int i = 1; i <= n; i++) {
            total += i;
        }
        return total;
    }

    /** 記号文字 '+' と '-' を交互に表示する（剰余判定方式） */
    public static String alternative1(int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            sb.append(i % 2 != 0 ? '-' : '+');
        }
        return sb.toString();
    }

    /** 記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式） */
    public static String alternative2(int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n / 2; i++) {
            sb.append("+-");
        }
        if (n % 2 != 0) sb.append('+');
        return sb.toString();
    }

    /** 縦横が整数で面積が area の長方形の辺の長さを列挙する */
    public static String rectangle(int area) {
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= area; i++) {
            if ((long) i * i > area) break;
            if (area % i != 0) continue;
            sb.append(i).append("x").append(area / i).append(" ");
        }
        return sb.toString();
    }

    /** 九九の表を返す */
    public static String multiplicationTable() {
        StringBuilder sb = new StringBuilder();
        sb.append("-".repeat(27)).append("\n");
        for (int i = 1; i <= 9; i++) {
            for (int j = 1; j <= 9; j++) {
                sb.append(String.format("%3d", i * j));
            }
            sb.append("\n");
        }
        sb.append("-".repeat(27));
        return sb.toString();
    }

    /** 左下側が直角の二等辺三角形を返す */
    public static String triangleLb(int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            sb.append("*".repeat(i + 1)).append("\n");
        }
        return sb.toString();
    }
}
