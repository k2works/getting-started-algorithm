# frozen_string_literal: true

require "digest"

# 第3章 探索アルゴリズム

module Algorithm
  # 配列aからkeyと等価な要素を線形探索（while文）
  def self.ssearch_while(a, key)
    i = 0
    loop do
      return -1 if i == a.length
      return i if a[i] == key

      i += 1
    end
  end

  # 配列aからkeyと等価な要素を線形探索（each文）
  def self.ssearch_for(a, key)
    a.each_with_index do |val, i|
      return i if val == key
    end
    -1
  end

  # 配列aからkeyと一致する要素を線形探索（番兵法）
  def self.ssearch_sentinel(a, key)
    arr = a.dup
    arr << key # 番兵を追加
    i = 0
    i += 1 until arr[i] == key
    i == a.length ? -1 : i
  end

  # 配列aからkeyと一致する要素を二分探索
  def self.bseach(a, key)
    pl = 0
    pr = a.length - 1
    loop do
      pc = (pl + pr) / 2
      return pc if a[pc] == key

      if a[pc] < key
        pl = pc + 1
      else
        pr = pc - 1
      end
      return -1 if pl > pr
    end
  end

  # チェイン法ハッシュのノード
  class ChainNode
    attr_accessor :key, :value, :next_node

    def initialize(key, value, next_node = nil)
      @key = key
      @value = value
      @next_node = next_node
    end
  end

  # チェイン法を実現するハッシュクラス
  class ChainedHash
    def initialize(capacity)
      @capacity = capacity
      @table = Array.new(@capacity)
    end

    def hash_value(key)
      if key.is_a?(Integer)
        key % @capacity
      else
        Digest::SHA256.hexdigest(key.to_s).to_i(16) % @capacity
      end
    end

    def search(key)
      h = hash_value(key)
      p = @table[h]
      while p
        return p.value if p.key == key

        p = p.next_node
      end
      nil
    end

    def add(key, value)
      h = hash_value(key)
      p = @table[h]
      while p
        return false if p.key == key

        p = p.next_node
      end
      @table[h] = ChainNode.new(key, value, @table[h])
      true
    end

    def remove(key)
      h = hash_value(key)
      p = @table[h]
      pp = nil
      while p
        if p.key == key
          if pp.nil?
            @table[h] = p.next_node
          else
            pp.next_node = p.next_node
          end
          return true
        end
        pp = p
        p = p.next_node
      end
      false
    end
  end

  # オープンアドレス法ハッシュのバケット状態
  module BucketStatus
    OCCUPIED = :occupied
    EMPTY = :empty
    DELETED = :deleted
  end

  # オープンアドレス法ハッシュのバケット
  class Bucket
    attr_accessor :key, :value, :stat

    def initialize(key = nil, value = nil, stat = BucketStatus::EMPTY)
      @key = key
      @value = value
      @stat = stat
    end
  end

  # オープンアドレス法（線形探索法）を実現するハッシュクラス
  class OpenHash
    def initialize(capacity)
      @capacity = capacity
      @table = Array.new(@capacity) { Bucket.new }
    end

    def hash_value(key)
      if key.is_a?(Integer)
        key % @capacity
      else
        Digest::MD5.hexdigest(key.to_s).to_i(16) % @capacity
      end
    end

    def search(key)
      h = hash_value(key)
      @capacity.times do
        p = @table[h]
        return nil if p.stat == BucketStatus::EMPTY
        return p.value if p.stat == BucketStatus::OCCUPIED && p.key == key

        h = (h + 1) % @capacity
      end
      nil
    end

    def add(key, value)
      return false unless search(key).nil?

      h = hash_value(key)
      @capacity.times do
        p = @table[h]
        if [BucketStatus::EMPTY, BucketStatus::DELETED].include?(p.stat)
          @table[h] = Bucket.new(key, value, BucketStatus::OCCUPIED)
          return true
        end
        h = (h + 1) % @capacity
      end
      false
    end

    def remove(key)
      h = hash_value(key)
      @capacity.times do
        p = @table[h]
        return false if p.stat == BucketStatus::EMPTY

        if p.stat == BucketStatus::OCCUPIED && p.key == key
          p.stat = BucketStatus::DELETED
          return true
        end
        h = (h + 1) % @capacity
      end
      false
    end
  end
end
