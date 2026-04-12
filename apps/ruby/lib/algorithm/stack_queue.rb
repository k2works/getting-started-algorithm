# frozen_string_literal: true

# 第4章 スタックとキュー

module Algorithm
  # 固定長スタック
  class FixedStack
    class Empty < StandardError; end
    class Full < StandardError; end

    def initialize(capacity)
      @stk = Array.new(capacity)
      @capacity = capacity
      @ptr = 0
    end

    def length
      @ptr
    end

    def include?(value)
      find(value) != -1
    end

    def empty?
      @ptr <= 0
    end

    def full?
      @ptr >= @capacity
    end

    def push(value)
      raise Full if full?

      @stk[@ptr] = value
      @ptr += 1
    end

    def pop
      raise Empty if empty?

      @ptr -= 1
      @stk[@ptr]
    end

    def peek
      raise Empty if empty?

      @stk[@ptr - 1]
    end

    def find(value)
      (@ptr - 1).downto(0) do |i|
        return i if @stk[i] == value
      end
      -1
    end

    def count(value)
      @stk[0...@ptr].count(value)
    end

    def clear
      @ptr = 0
    end

    def dump
      if empty?
        puts "スタックは空です"
      else
        puts @stk[0...@ptr].inspect
      end
    end
  end

  # 固定長キュー（リングバッファ）
  class FixedQueue
    class Empty < StandardError; end
    class Full < StandardError; end

    def initialize(capacity)
      @que = Array.new(capacity)
      @capacity = capacity
      @front = 0
      @rear = 0
      @num = 0
    end

    def length
      @num
    end

    def include?(value)
      find(value) != -1
    end

    def empty?
      @num <= 0
    end

    def full?
      @num >= @capacity
    end

    def enque(value)
      raise Full if full?

      @que[@rear] = value
      @rear += 1
      @num += 1
      @rear = 0 if @rear == @capacity
    end

    def deque
      raise Empty if empty?

      value = @que[@front]
      @front += 1
      @num -= 1
      @front = 0 if @front == @capacity
      value
    end

    def peek
      raise Empty if empty?

      @que[@front]
    end

    def find(value)
      @num.times do |i|
        idx = (i + @front) % @capacity
        return i if @que[idx] == value
      end
      -1
    end

    def count(value)
      c = 0
      @num.times do |i|
        idx = (i + @front) % @capacity
        c += 1 if @que[idx] == value
      end
      c
    end

    def clear
      @front = @rear = @num = 0
    end

    def dump
      if empty?
        puts "キューは空です"
      else
        @num.times do |i|
          print "#{@que[(i + @front) % @capacity]} "
        end
        puts
      end
    end
  end
end
