# frozen_string_literal: true

# 第9章 木構造

module Algorithm
  # 二分探索木のノード
  class BSTNode
    attr_accessor :key, :left, :right

    def initialize(key)
      @key = key
      @left = nil
      @right = nil
    end
  end

  # 二分探索木（Binary Search Tree）
  class BinarySearchTree
    class Empty < StandardError; end

    def initialize
      @root = nil
      @no = 0
    end

    def length
      @no
    end

    def include?(key)
      !search(key).nil?
    end

    def empty?
      @root.nil?
    end

    def search(key)
      ptr = @root
      while ptr
        return ptr if key == ptr.key

        ptr = key < ptr.key ? ptr.left : ptr.right
      end
      nil
    end

    def insert(key)
      if @root.nil?
        @root = BSTNode.new(key)
        @no += 1
        return
      end

      ptr = @root
      loop do
        return if key == ptr.key  # 重複は無視

        if key < ptr.key
          if ptr.left.nil?
            ptr.left = BSTNode.new(key)
            @no += 1
            return
          end
          ptr = ptr.left
        else
          if ptr.right.nil?
            ptr.right = BSTNode.new(key)
            @no += 1
            return
          end
          ptr = ptr.right
        end
      end
    end

    def delete(key)
      parent = nil
      ptr = @root
      is_left_child = false

      while ptr
        break if key == ptr.key

        parent = ptr
        if key < ptr.key
          is_left_child = true
          ptr = ptr.left
        else
          is_left_child = false
          ptr = ptr.right
        end
      end

      return if ptr.nil?

      @no -= 1

      if ptr.left.nil? && ptr.right.nil?
        replace_node(parent, is_left_child, nil)
      elsif ptr.right.nil?
        replace_node(parent, is_left_child, ptr.left)
      elsif ptr.left.nil?
        replace_node(parent, is_left_child, ptr.right)
      else
        successor_parent = ptr
        successor = ptr.right
        while successor.left
          successor_parent = successor
          successor = successor.left
        end
        ptr.key = successor.key
        if successor_parent.equal?(ptr)
          successor_parent.right = successor.right
        else
          successor_parent.left = successor.right
        end
        @no += 1  # delete で既に -1 しているので +1 で調整
      end
    end

    def min
      raise Empty if @root.nil?

      ptr = @root
      ptr = ptr.left while ptr.left
      ptr.key
    end

    def max
      raise Empty if @root.nil?

      ptr = @root
      ptr = ptr.right while ptr.right
      ptr.key
    end

    def inorder
      result = []
      _inorder(@root, result)
      result
    end

    def preorder
      result = []
      _preorder(@root, result)
      result
    end

    def postorder
      result = []
      _postorder(@root, result)
      result
    end

    private

    def replace_node(parent, is_left_child, new_node)
      if parent.nil?
        @root = new_node
      elsif is_left_child
        parent.left = new_node
      else
        parent.right = new_node
      end
    end

    def _inorder(node, result)
      return if node.nil?

      _inorder(node.left, result)
      result << node.key
      _inorder(node.right, result)
    end

    def _preorder(node, result)
      return if node.nil?

      result << node.key
      _preorder(node.left, result)
      _preorder(node.right, result)
    end

    def _postorder(node, result)
      return if node.nil?

      _postorder(node.left, result)
      _postorder(node.right, result)
      result << node.key
    end
  end
end
