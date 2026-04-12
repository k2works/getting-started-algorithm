# frozen_string_literal: true

# 第1章 基本的なアルゴリズム

module Algorithm
  # 3つの整数値の最大値を返す
  def self.max3(a, b, c)
    maximum = a
    maximum = b if b > maximum
    maximum = c if c > maximum
    maximum
  end

  # 3つの整数値の中央値を返す
  def self.med3(a, b, c)
    if a >= b
      if b >= c
        b
      elsif a <= c
        a
      else
        c
      end
    elsif a > c
      a
    elsif b > c
      c
    else
      b
    end
  end

  # 整数値の符号を判定する
  def self.judge_sign(n)
    if n > 0
      "その値は正です。"
    elsif n < 0
      "その値は負です。"
    else
      "その値は0です。"
    end
  end

  # while ループで 1 から n までの総和を求める
  def self.sum_1_to_n_while(n)
    total = 0
    i = 1
    while i <= n
      total += i
      i += 1
    end
    total
  end

  # for ループで 1 から n までの総和を求める
  def self.sum_1_to_n_for(n)
    total = 0
    (1..n).each { |i| total += i }
    total
  end

  # 記号文字 '+' と '-' を交互に表示する（剰余判定方式）
  def self.alternative_1(n)
    result = ""
    n.times { |i| result += i.odd? ? "-" : "+" }
    result
  end

  # 記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式）
  def self.alternative_2(n)
    result = "+-" * (n / 2)
    result += "+" if n.odd?
    result
  end

  # 縦横が整数で面積が area の長方形の辺の長さを列挙する
  def self.rectangle(area)
    result = ""
    (1..area).each do |i|
      break if i * i > area
      next if area % i != 0

      result += "#{i}x#{area / i} "
    end
    result
  end

  # 九九の表を返す
  def self.multiplication_table
    result = "-" * 27 + "\n"
    (1..9).each do |i|
      (1..9).each { |j| result += format("%3d", i * j) }
      result += "\n"
    end
    result + "-" * 27
  end

  # 左下側が直角の二等辺三角形を返す
  def self.traiangle_lb(n)
    result = ""
    n.times { |i| result += "*" * (i + 1) + "\n" }
    result
  end
end
