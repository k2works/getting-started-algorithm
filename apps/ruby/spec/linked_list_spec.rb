# frozen_string_literal: true

require "algorithm/linked_list"

RSpec.describe "第8章 リスト" do
  describe "Algorithm::LinkedList" do
    let(:list) { Algorithm::LinkedList.new }

    it "先頭への挿入と探索" do
      list.add_first(1)
      list.add_first(2)
      list.add_first(3)
      expect(list.length).to eq(3)
      expect(list.search(2)).not_to be nil
    end

    it "末尾への挿入" do
      list.add_last(1)
      list.add_last(2)
      list.add_last(3)
      expect(list.length).to eq(3)
    end

    it "先頭の削除" do
      list.add_first(1)
      list.add_first(2)
      list.remove_first
      expect(list.length).to eq(1)
      expect(list.search(2)).to be nil
    end

    it "末尾の削除" do
      list.add_last(1)
      list.add_last(2)
      list.remove_last
      expect(list.length).to eq(1)
      expect(list.search(2)).to be nil
    end

    it "空リストからの削除は例外" do
      expect { list.remove_first }.to raise_error(Algorithm::LinkedList::Empty)
      expect { list.remove_last }.to raise_error(Algorithm::LinkedList::Empty)
    end

    it "include?" do
      list.add_first(42)
      expect(list.include?(42)).to be true
      expect(list.include?(99)).to be false
    end

    it "clear" do
      list.add_first(1)
      list.clear
      expect(list.empty?).to be true
    end

    it "ノード削除" do
      list.add_first(1)
      list.add_first(2)
      node = list.search(2)
      list.remove(node)
      expect(list.include?(2)).to be false
    end
  end

  describe "Algorithm::DoublyLinkedList" do
    let(:list) { Algorithm::DoublyLinkedList.new }

    it "先頭への挿入と探索" do
      list.add_first(1)
      list.add_first(2)
      list.add_first(3)
      expect(list.length).to eq(3)
      expect(list.search(2)).not_to be nil
    end

    it "末尾への挿入" do
      list.add_last(1)
      list.add_last(2)
      list.add_last(3)
      expect(list.length).to eq(3)
    end

    it "ノード削除" do
      list.add_first(1)
      list.add_first(2)
      node = list.search(2)
      list.remove(node)
      expect(list.include?(2)).to be false
    end

    it "clear" do
      list.add_first(1)
      list.clear
      expect(list.empty?).to be true
    end
  end

  describe "Algorithm::ArrayLinkedList" do
    let(:list) { Algorithm::ArrayLinkedList.new(10) }

    it "先頭への挿入と探索" do
      list.add_first(1)
      list.add_first(2)
      list.add_first(3)
      expect(list.length).to eq(3)
      expect(list.search(2)).not_to eq(Algorithm::NULL)
    end

    it "末尾への挿入" do
      list.add_last(1)
      list.add_last(2)
      list.add_last(3)
      expect(list.length).to eq(3)
    end

    it "先頭の削除" do
      list.add_first(1)
      list.add_first(2)
      list.remove_first
      expect(list.length).to eq(1)
      expect(list.search(2)).to eq(Algorithm::NULL)
    end
  end
end
