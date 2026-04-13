// chapter01: 基本的なアルゴリズム

/// 3つの整数値の最大値を返す
pub fn max3(a: i32, b: i32, c: i32) -> i32 {
    let mut maximum = a;
    if b > maximum {
        maximum = b;
    }
    if c > maximum {
        maximum = c;
    }
    maximum
}

/// 3つの整数値の中央値を返す
pub fn med3(a: i32, b: i32, c: i32) -> i32 {
    if a >= b {
        if b >= c {
            b
        } else if a <= c {
            a
        } else {
            c
        }
    } else if a > c {
        a
    } else if b > c {
        c
    } else {
        b
    }
}

/// 整数値の符号を判定する
pub fn judge_sign(n: i32) -> &'static str {
    if n > 0 {
        "positive"
    } else if n < 0 {
        "negative"
    } else {
        "zero"
    }
}

/// while 文で 1 から n までの総和を求める
pub fn sum_while(n: u32) -> u32 {
    let mut total = 0u32;
    let mut i = 1u32;
    while i <= n {
        total += i;
        i += 1;
    }
    total
}

/// for 文で 1 から n までの総和を求める
pub fn sum_for(n: u32) -> u32 {
    let mut total = 0u32;
    for i in 1..=n {
        total += i;
    }
    total
}

/// 記号文字 '+' と '-' を交互に表示する（剰余判定方式）
pub fn alternative_1(n: u32) -> String {
    let mut result = String::new();
    for i in 0..n {
        if i % 2 == 0 {
            result.push('+');
        } else {
            result.push('-');
        }
    }
    result
}

/// 記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式）
pub fn alternative_2(n: u32) -> String {
    let mut result = "+-".repeat((n / 2) as usize);
    if n % 2 != 0 {
        result.push('+');
    }
    result
}

/// 縦横が整数で面積が area の長方形の辺の長さを列挙する
pub fn rectangle(area: u32) -> String {
    let mut result = String::new();
    for i in 1..=area {
        if i * i > area {
            break;
        }
        if area % i != 0 {
            continue;
        }
        result.push_str(&format!("{}x{} ", i, area / i));
    }
    result
}

/// 九九の表を返す
pub fn multiplication_table() -> String {
    let mut result = format!("{}\n", "-".repeat(27));
    for i in 1..=9u32 {
        for j in 1..=9u32 {
            result.push_str(&format!("{:3}", i * j));
        }
        result.push('\n');
    }
    result.push_str(&"-".repeat(27));
    result
}

/// 左下側が直角の二等辺三角形を返す
pub fn triangle_lb(n: u32) -> String {
    let mut result = String::new();
    for i in 0..n {
        for _ in 0..=i {
            result.push('*');
        }
        result.push('\n');
    }
    result
}

/// 各桁の合計を返す
pub fn sum_of_digits(mut n: u32) -> u32 {
    let mut total = 0u32;
    while n > 0 {
        total += n % 10;
        n /= 10;
    }
    total
}

/// n 以下の正の奇数を昇順で返す
pub fn odd_numbers(n: u32) -> Vec<u32> {
    let mut result = Vec::new();
    let mut i = 1u32;
    while i <= n {
        result.push(i);
        i += 2;
    }
    result
}

/// n x n の掛け算表を 2次元ベクターで返す
pub fn multiplication_table_n(n: u32) -> Vec<Vec<u32>> {
    let mut table = Vec::new();
    for i in 1..=n {
        let mut row = Vec::new();
        for j in 1..=n {
            row.push(i * j);
        }
        table.push(row);
    }
    table
}

#[cfg(test)]
mod tests {
    use super::*;

    // ========================================
    // 3値の最大値
    // ========================================
    mod max3_tests {
        use super::*;

        #[test]
        fn test_max3_all_cases() {
            let cases = vec![
                (3, 2, 1, 3), // a > b > c
                (3, 2, 2, 3), // a > b = c
                (3, 1, 2, 3), // a > c > b
                (3, 2, 3, 3), // a = c > b
                (2, 1, 3, 3), // c > a > b
                (3, 3, 2, 3), // a = b > c
                (3, 3, 3, 3), // a = b = c
                (2, 2, 3, 3), // c > a = b
                (2, 3, 1, 3), // b > a > c
                (2, 3, 2, 3), // b > a = c
                (1, 3, 2, 3), // b > c > a
                (2, 3, 3, 3), // b = c > a
                (1, 2, 3, 3), // c > b > a
            ];
            for (a, b, c, expected) in cases {
                assert_eq!(
                    max3(a, b, c),
                    expected,
                    "max3({}, {}, {}) should be {}",
                    a,
                    b,
                    c,
                    expected
                );
            }
        }
    }

    // ========================================
    // 3値の中央値
    // ========================================
    mod med3_tests {
        use super::*;

        #[test]
        fn test_med3_all_cases() {
            let cases = vec![
                (3, 2, 1, 2), // a > b > c
                (3, 2, 2, 2), // a > b = c
                (3, 1, 2, 2), // a > c > b
                (3, 2, 3, 3), // a = c > b
                (2, 1, 3, 2), // c > a > b
                (3, 3, 2, 3), // a = b > c
                (3, 3, 3, 3), // a = b = c
                (2, 2, 3, 2), // c > a = b
                (2, 3, 1, 2), // b > a > c
                (2, 3, 2, 2), // b > a = c
                (1, 3, 2, 2), // b > c > a
                (2, 3, 3, 3), // b = c > a
                (1, 2, 3, 2), // c > b > a
            ];
            for (a, b, c, expected) in cases {
                assert_eq!(
                    med3(a, b, c),
                    expected,
                    "med3({}, {}, {}) should be {}",
                    a,
                    b,
                    c,
                    expected
                );
            }
        }
    }

    // ========================================
    // 条件判定と分岐
    // ========================================
    mod judge_sign_tests {
        use super::*;

        #[test]
        fn test_positive() {
            assert_eq!(judge_sign(17), "positive");
        }

        #[test]
        fn test_negative() {
            assert_eq!(judge_sign(-5), "negative");
        }

        #[test]
        fn test_zero() {
            assert_eq!(judge_sign(0), "zero");
        }
    }

    // ========================================
    // 繰り返し処理 -- 1 から n までの総和
    // ========================================
    mod sum_tests {
        use super::*;

        #[test]
        fn test_sum_while() {
            assert_eq!(sum_while(5), 15);
        }

        #[test]
        fn test_sum_for() {
            assert_eq!(sum_for(5), 15);
        }

        #[test]
        fn test_sum_zero() {
            assert_eq!(sum_while(0), 0);
            assert_eq!(sum_for(0), 0);
        }

        #[test]
        fn test_sum_one() {
            assert_eq!(sum_while(1), 1);
            assert_eq!(sum_for(1), 1);
        }
    }

    // ========================================
    // 繰り返し処理 -- 記号文字の交互表示
    // ========================================
    mod alternative_tests {
        use super::*;

        #[test]
        fn test_alternative_1_even() {
            assert_eq!(alternative_1(12), "+-+-+-+-+-+-");
        }

        #[test]
        fn test_alternative_2_even() {
            assert_eq!(alternative_2(12), "+-+-+-+-+-+-");
        }

        #[test]
        fn test_alternative_odd() {
            assert_eq!(alternative_1(5), "+-+-+");
            assert_eq!(alternative_2(5), "+-+-+");
        }
    }

    // ========================================
    // 繰り返し処理 -- 長方形の辺の長さを列挙
    // ========================================
    mod rectangle_tests {
        use super::*;

        #[test]
        fn test_rectangle() {
            assert_eq!(rectangle(32), "1x32 2x16 4x8 ");
        }
    }

    // ========================================
    // 多重ループ -- 九九の表
    // ========================================
    mod multiplication_table_tests {
        use super::*;

        #[test]
        fn test_multiplication_table() {
            let expected = "\
---------------------------
  1  2  3  4  5  6  7  8  9
  2  4  6  8 10 12 14 16 18
  3  6  9 12 15 18 21 24 27
  4  8 12 16 20 24 28 32 36
  5 10 15 20 25 30 35 40 45
  6 12 18 24 30 36 42 48 54
  7 14 21 28 35 42 49 56 63
  8 16 24 32 40 48 56 64 72
  9 18 27 36 45 54 63 72 81
---------------------------";
            assert_eq!(multiplication_table(), expected);
        }
    }

    // ========================================
    // 多重ループ -- 直角三角形の表示
    // ========================================
    mod triangle_lb_tests {
        use super::*;

        #[test]
        fn test_triangle_lb() {
            let expected = "*\n**\n***\n****\n*****\n";
            assert_eq!(triangle_lb(5), expected);
        }
    }

    // ========================================
    // 桁の合計
    // ========================================
    mod sum_of_digits_tests {
        use super::*;

        #[test]
        fn test_single_digit() {
            assert_eq!(sum_of_digits(5), 5);
        }

        #[test]
        fn test_multiple_digits() {
            assert_eq!(sum_of_digits(123), 6);
        }

        #[test]
        fn test_zero() {
            assert_eq!(sum_of_digits(0), 0);
        }

        #[test]
        fn test_large_number() {
            assert_eq!(sum_of_digits(9999), 36);
        }
    }

    // ========================================
    // 正整数の列（奇数）
    // ========================================
    mod odd_numbers_tests {
        use super::*;

        #[test]
        fn test_odd_numbers_up_to_10() {
            assert_eq!(odd_numbers(10), vec![1, 3, 5, 7, 9]);
        }

        #[test]
        fn test_odd_numbers_up_to_1() {
            assert_eq!(odd_numbers(1), vec![1]);
        }

        #[test]
        fn test_odd_numbers_up_to_0() {
            assert_eq!(odd_numbers(0), Vec::<u32>::new());
        }

        #[test]
        fn test_odd_numbers_up_to_7() {
            assert_eq!(odd_numbers(7), vec![1, 3, 5, 7]);
        }
    }

    // ========================================
    // 掛け算表（n x n）
    // ========================================
    mod multiplication_table_n_tests {
        use super::*;

        #[test]
        fn test_multiplication_table_3x3() {
            let expected = vec![
                vec![1, 2, 3],
                vec![2, 4, 6],
                vec![3, 6, 9],
            ];
            assert_eq!(multiplication_table_n(3), expected);
        }

        #[test]
        fn test_multiplication_table_1x1() {
            assert_eq!(multiplication_table_n(1), vec![vec![1]]);
        }
    }
}
