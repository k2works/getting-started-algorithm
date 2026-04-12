# frozen_string_literal: true

# 第8章 リスト（連結リスト）

module Algorithm
  # 単方向連結リストのノード
  class LLNode
    attr_accessor :data, :next_node

    def initialize(data, next_node = nil)
      @data = data
      @next_node = next_node
    end
  end

  # 線形リスト（単方向連結リスト）
  class LinkedList
    class Empty < StandardError; end

    def initialize
      @head = nil
      @no = 0
    end

    def length
      @no
    end

    def include?(data)
      !search(data).nil?
    end

    def each
      ptr = @head
      while ptr
        yield ptr
        ptr = ptr.next_node
      end
    end

    def empty?
      @head.nil?
    end

    def search(data)
      ptr = @head
      while ptr
        return ptr if ptr.data == data

        ptr = ptr.next_node
      end
      nil
    end

    def add_first(data)
      @head = LLNode.new(data, @head)
      @no += 1
    end

    def add_last(data)
      if @head.nil?
        @head = LLNode.new(data)
      else
        ptr = @head
        ptr = ptr.next_node while ptr.next_node
        ptr.next_node = LLNode.new(data)
      end
      @no += 1
    end

    def remove_first
      raise Empty if @head.nil?

      @head = @head.next_node
      @no -= 1
    end

    def remove_last
      raise Empty if @head.nil?

      if @head.next_node.nil?
        @head = nil
      else
        ptr = @head
        ptr = ptr.next_node while ptr.next_node && ptr.next_node.next_node
        ptr.next_node = nil
      end
      @no -= 1
    end

    def remove(node)
      return if @head.nil?

      if @head.equal?(node)
        @head = @head.next_node
        @no -= 1
        return
      end
      ptr = @head
      while ptr.next_node
        if ptr.next_node.equal?(node)
          ptr.next_node = node.next_node
          @no -= 1
          return
        end
        ptr = ptr.next_node
      end
    end

    def clear
      @head = nil
      @no = 0
    end
  end

  # 双方向連結リストのノード
  class DLLNode
    attr_accessor :data, :prev_node, :next_node

    def initialize(data = nil, prev_node = nil, next_node = nil)
      @data = data
      @prev_node = prev_node
      @next_node = next_node
    end
  end

  # 双方向連結リスト（番兵ノード使用）
  class DoublyLinkedList
    def initialize
      # 番兵ノード: head.next_node が先頭、head.prev_node が末尾
      @head = DLLNode.new
      @head.prev_node = @head
      @head.next_node = @head
      @no = 0
    end

    def length
      @no
    end

    def include?(data)
      !search(data).nil?
    end

    def each
      ptr = @head.next_node
      while !ptr.equal?(@head)
        yield ptr
        ptr = ptr.next_node
      end
    end

    def empty?
      @no == 0
    end

    def search(data)
      ptr = @head.next_node
      while !ptr.equal?(@head)
        return ptr if ptr.data == data

        ptr = ptr.next_node
      end
      nil
    end

    def add_first(data)
      node = DLLNode.new(data, @head, @head.next_node)
      @head.next_node.prev_node = node
      @head.next_node = node
      @no += 1
    end

    def add_last(data)
      node = DLLNode.new(data, @head.prev_node, @head)
      @head.prev_node.next_node = node
      @head.prev_node = node
      @no += 1
    end

    def remove(node)
      return if empty?

      node.prev_node.next_node = node.next_node
      node.next_node.prev_node = node.prev_node
      @no -= 1
    end

    def clear
      @head.prev_node = @head
      @head.next_node = @head
      @no = 0
    end
  end

  NULL = -1

  # 線形リストノードクラス（配列カーソル版）
  class ArrayNode
    attr_accessor :data, :next_idx, :dnext

    def initialize(data = NULL, next_idx = NULL, dnext = NULL)
      @data = data
      @next_idx = next_idx
      @dnext = dnext
    end
  end

  # 線形リストクラス（配列カーソル版）
  class ArrayLinkedList
    def initialize(capacity)
      @head = NULL
      @current = NULL
      @max = NULL
      @deleted = NULL
      @capacity = capacity
      @n = Array.new(@capacity) { ArrayNode.new }
      @no = 0
    end

    def length
      @no
    end

    def get_insert_index
      if @deleted == NULL
        if @max + 1 < @capacity
          @max += 1
          return @max
        else
          return NULL
        end
      else
        rec = @deleted
        @deleted = @n[rec].dnext
        rec
      end
    end

    def add_first(data)
      ptr = @head
      rec = get_insert_index
      if rec != NULL
        @head = @current = rec
        @n[@head] = ArrayNode.new(data, ptr)
        @no += 1
      end
    end

    def add_last(data)
      if @head == NULL
        add_first(data)
      else
        ptr = @head
        ptr = @n[ptr].next_idx while @n[ptr].next_idx != NULL
        rec = get_insert_index
        if rec != NULL
          @n[ptr].next_idx = @current = rec
          @n[rec] = ArrayNode.new(data)
          @no += 1
        end
      end
    end

    def search(data)
      ptr = @head
      while ptr != NULL
        if @n[ptr].data == data
          @current = ptr
          return ptr
        end
        ptr = @n[ptr].next_idx
      end
      NULL
    end

    def remove_first
      if @head != NULL
        ptr = @head
        @head = @current = @n[ptr].next_idx
        @n[ptr].dnext = @deleted
        @deleted = ptr
        @no -= 1
      end
    end
  end
end
