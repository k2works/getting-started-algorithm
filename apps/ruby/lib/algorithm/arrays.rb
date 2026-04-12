# frozen_string_literal: true

# 第2章 配列

module Algorithm
  # 配列aの要素の最大値を返す
  def self.max_of(a)
    maximum = a[0]
    (1...a.length).each do |i|
      maximum = a[i] if a[i] > maximum
    end
    maximum
  end

  # 配列aの要素の並びを反転する（破壊的）
  def self.reverse_array(a)
    n = a.length
    (n / 2).times do |i|
      a[i], a[n - i - 1] = a[n - i - 1], a[i]
    end
  end

  # 整数値xをr進数に変換した数値を表す文字列を返す
  def self.card_conv(x, r)
    d = ""
    dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    while x > 0
      d += dchar[x % r]
      x /= r
    end
    d.reverse
  end

  # x以下の素数を列挙する（第1版）— 除算回数を返す
  def self.prime1(x)
    counter = 0
    (2..x).each do |n|
      (2...n).each do |i|
        counter += 1
        break if (n % i).zero?
      end
    end
    counter
  end

  # x以下の素数を列挙する（第2版）— 除算回数を返す
  def self.prime2(x)
    counter = 0
    ptr = 0
    prime = Array.new(500)

    prime[ptr] = 2
    ptr += 1

    (3..x).step(2) do |n|
      found_divisor = false
      (1...ptr).each do |i|
        counter += 1
        if (n % prime[i]).zero?
          found_divisor = true
          break
        end
      end
      unless found_divisor
        prime[ptr] = n
        ptr += 1
      end
    end

    counter
  end

  # x以下の素数を列挙する（第3版）— 除算回数を返す
  def self.prime3(x)
    counter = 0
    ptr = 0
    prime = Array.new(500)

    prime[ptr] = 2
    ptr += 1
    prime[ptr] = 3
    ptr += 1

    (5..1000).step(2) do |n|
      i = 1
      found_divisor = false
      while prime[i] * prime[i] <= n
        counter += 2
        if (n % prime[i]).zero?
          found_divisor = true
          break
        end
        i += 1
      end
      unless found_divisor
        prime[ptr] = n
        ptr += 1
        counter += 1
      end
    end

    counter
  end
end
