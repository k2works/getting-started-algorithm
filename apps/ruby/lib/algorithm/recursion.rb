# frozen_string_literal: true

# 第5章 再帰アルゴリズム

module Algorithm
  # n の階乗を再帰的に計算
  def self.factorial(n)
    return 1 if n <= 0

    n * factorial(n - 1)
  end

  # ユークリッドの互除法で最大公約数を求める
  def self.gcd(x, y)
    return x if y == 0

    gcd(y, x % y)
  end

  # 1 から n までの和を再帰的に計算
  def self.recursive_sum(n)
    return 0 if n <= 0

    n + recursive_sum(n - 1)
  end

  # ハノイの塔: n 枚の円盤を src から dst へ via を経由して移動する手順を返す
  def self.hanoi(n, src, dst, via)
    return [[src, dst]] if n == 1

    moves = []
    moves.concat(hanoi(n - 1, src, via, dst))
    moves << [src, dst]
    moves.concat(hanoi(n - 1, via, dst, src))
    moves
  end

  # 真に再帰的な関数（複数の再帰呼び出しを含む）
  def self.recure(n, list)
    if n > 0
      recure(n - 1, list)
      list << n
      recure(n - 2, list)
    end
    list
  end

  # 真に再帰的な関数（末尾再帰の一部を除去した版）
  def self.recure2(n, list)
    while n > 0
      recure2(n - 1, list)
      list << n
      n -= 2
    end
    list
  end

  # 迷路をバックトラッキングで解く
  # maze[r][c] == 0: 通路, 1: 壁
  def self.maze_solve(maze, row, col, goal_row, goal_col, visited = nil)
    visited ||= Set.new
    return true if row == goal_row && col == goal_col

    rows = maze.length
    cols = maze[0].length
    visited.add([row, col])

    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dr, dc|
      nr = row + dr
      nc = col + dc
      next unless nr >= 0 && nr < rows && nc >= 0 && nc < cols
      next unless maze[nr][nc] == 0
      next if visited.include?([nr, nc])
      return true if maze_solve(maze, nr, nc, goal_row, goal_col, visited)
    end

    false
  end

  # 8 王妃問題（全組み合わせ列挙）
  class EightQueen
    attr_reader :result

    def initialize
      @result = []
      @pos = Array.new(8, 0)
    end

    def put
      @result << @pos.dup
    end

    def set(i)
      8.times do |j|
        @pos[i] = j
        if i == 7
          put
        else
          set(i + 1)
        end
      end
    end
  end

  # 8 王妃問題（行制約あり）
  class EightQueen2
    attr_reader :result

    def initialize
      @result = []
      @pos = Array.new(8, 0)
      @flag = Array.new(8, false)
    end

    def put
      @result << @pos.dup
    end

    def set(i)
      8.times do |j|
        next if @flag[j]

        @pos[i] = j
        if i == 7
          put
        else
          @flag[j] = true
          set(i + 1)
          @flag[j] = false
        end
      end
    end
  end

  # 8 王妃問題（行・対角線制約あり）
  class EightQueen3
    attr_reader :result

    def initialize
      @result = []
      @pos = Array.new(8, 0)
      @flag_a = Array.new(8, false)   # 各行のフラグ
      @flag_b = Array.new(15, false)  # 右上がり対角線のフラグ
      @flag_c = Array.new(15, false)  # 右下がり対角線のフラグ
    end

    def put
      @result << @pos.dup
    end

    def set(i)
      8.times do |j|
        next if @flag_a[j] || @flag_b[i + j] || @flag_c[i - j + 7]

        @pos[i] = j
        if i == 7
          put
        else
          @flag_a[j] = true
          @flag_b[i + j] = true
          @flag_c[i - j + 7] = true
          set(i + 1)
          @flag_a[j] = false
          @flag_b[i + j] = false
          @flag_c[i - j + 7] = false
        end
      end
    end
  end
end
