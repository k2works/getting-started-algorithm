// chapter02: 配列

/// 配列の要素の最大値とそのインデックスを返す
///
/// # Examples
/// ```
/// assert_eq!(chapter02::max_of_array(&[172, 153, 192, 140, 165]), (192, 2));
/// ```
pub fn max_of_array(arr: &[i32]) -> (i32, usize) {
    let mut max_val = arr[0];
    let mut max_idx = 0;
    for i in 1..arr.len() {
        if arr[i] > max_val {
            max_val = arr[i];
            max_idx = i;
        }
    }
    (max_val, max_idx)
}

/// 配列の要素の並びを反転する（in-place）
///
/// # Examples
/// ```
/// let mut a = vec![2, 5, 1, 3, 9, 6, 7];
/// chapter02::reverse_array(&mut a);
/// assert_eq!(a, vec![7, 6, 9, 3, 1, 5, 2]);
/// ```
pub fn reverse_array(arr: &mut [i32]) {
    let n = arr.len();
    for i in 0..n / 2 {
        arr.swap(i, n - i - 1);
    }
}

/// 整数値 x を r 進数に変換した文字列を返す
///
/// # Examples
/// ```
/// assert_eq!(chapter02::cardinal(29, 2), "11101");
/// assert_eq!(chapter02::cardinal(255, 16), "FF");
/// ```
pub fn cardinal(mut x: u64, r: u32) -> String {
    const DCHAR: &[u8] = b"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    let r = r as u64;
    let mut digits = Vec::new();

    while x > 0 {
        digits.push(DCHAR[(x % r) as usize] as char);
        x /= r;
    }

    if digits.is_empty() {
        return "0".to_string();
    }

    digits.iter().rev().collect()
}

/// 素数列挙（第 1 版）— x 以下の素数を列挙する際の除算回数を返す
///
/// # Examples
/// ```
/// assert_eq!(chapter02::prime1(1000), 78022);
/// ```
pub fn prime1(x: usize) -> u64 {
    let mut counter: u64 = 0;
    for n in 2..=x {
        for i in 2..n {
            counter += 1;
            if n % i == 0 {
                break;
            }
        }
    }
    counter
}

/// 素数列挙（第 2 版）— 奇数のみチェック、既知の素数で割る
///
/// # Examples
/// ```
/// assert_eq!(chapter02::prime2(1000), 14622);
/// ```
pub fn prime2(x: usize) -> u64 {
    let mut counter: u64 = 0;
    let mut prime = vec![0u64; 500];
    let mut ptr: usize = 0;

    prime[ptr] = 2;
    ptr += 1;

    let mut n = 3usize;
    while n <= x {
        let mut is_prime = true;
        for i in 1..ptr {
            counter += 1;
            if (n as u64) % prime[i] == 0 {
                is_prime = false;
                break;
            }
        }
        if is_prime {
            prime[ptr] = n as u64;
            ptr += 1;
        }
        n += 2;
    }
    counter
}

/// 素数列挙（第 3 版）— 平方根以下の素数でのみチェック（エラトステネス的最適化）
///
/// # Examples
/// ```
/// assert_eq!(chapter02::prime3(1000), 3774);
/// ```
pub fn prime3(x: usize) -> u64 {
    let mut counter: u64 = 0;
    let mut prime = vec![0u64; 500];
    let mut ptr: usize = 0;

    prime[ptr] = 2;
    ptr += 1;
    prime[ptr] = 3;
    ptr += 1;

    let mut n = 5usize;
    while n <= x {
        let mut i = 1usize;
        let mut is_prime = true;
        while prime[i] * prime[i] <= n as u64 {
            counter += 2;
            if (n as u64) % prime[i] == 0 {
                is_prime = false;
                break;
            }
            i += 1;
        }
        if is_prime {
            prime[ptr] = n as u64;
            ptr += 1;
            counter += 1;
        }
        n += 2;
    }
    counter
}

#[cfg(test)]
mod tests {
    use super::*;

    // ========================================
    // 配列の最大値
    // ========================================
    mod test_max_of_array {
        use super::*;

        #[test]
        fn test_max_of_array_basic() {
            assert_eq!(max_of_array(&[172, 153, 192, 140, 165]), (192, 2));
        }

        #[test]
        fn test_max_of_array_single() {
            assert_eq!(max_of_array(&[42]), (42, 0));
        }

        #[test]
        fn test_max_of_array_equal() {
            assert_eq!(max_of_array(&[5, 5, 5]), (5, 0));
        }

        #[test]
        fn test_max_of_array_negative() {
            assert_eq!(max_of_array(&[-3, -1, -5]), (-1, 1));
        }

        #[test]
        fn test_max_of_array_last() {
            assert_eq!(max_of_array(&[1, 2, 3, 4, 5]), (5, 4));
        }
    }

    // ========================================
    // 配列の逆順
    // ========================================
    mod test_reverse_array {
        use super::*;

        #[test]
        fn test_reverse_array_odd() {
            let mut a = vec![2, 5, 1, 3, 9, 6, 7];
            reverse_array(&mut a);
            assert_eq!(a, vec![7, 6, 9, 3, 1, 5, 2]);
        }

        #[test]
        fn test_reverse_array_even() {
            let mut a = vec![1, 2, 3, 4];
            reverse_array(&mut a);
            assert_eq!(a, vec![4, 3, 2, 1]);
        }

        #[test]
        fn test_reverse_array_single() {
            let mut a = vec![42];
            reverse_array(&mut a);
            assert_eq!(a, vec![42]);
        }

        #[test]
        fn test_reverse_array_empty() {
            let mut a: Vec<i32> = vec![];
            reverse_array(&mut a);
            assert_eq!(a, Vec::<i32>::new());
        }
    }

    // ========================================
    // 基数変換
    // ========================================
    mod test_cardinal {
        use super::*;

        #[test]
        fn test_binary() {
            assert_eq!(cardinal(29, 2), "11101");
        }

        #[test]
        fn test_octal() {
            assert_eq!(cardinal(29, 8), "35");
        }

        #[test]
        fn test_hex() {
            assert_eq!(cardinal(255, 16), "FF");
        }

        #[test]
        fn test_zero() {
            assert_eq!(cardinal(0, 2), "0");
        }

        #[test]
        fn test_decimal() {
            assert_eq!(cardinal(100, 10), "100");
        }
    }

    // ========================================
    // 素数列挙
    // ========================================
    mod test_prime {
        use super::*;

        #[test]
        fn test_prime1() {
            assert_eq!(prime1(1000), 78022);
        }

        #[test]
        fn test_prime2() {
            assert_eq!(prime2(1000), 14622);
        }

        #[test]
        fn test_prime3() {
            assert_eq!(prime3(1000), 3774);
        }
    }
}
