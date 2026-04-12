# frozen_string_literal: true

require "algorithm/tree"

RSpec.describe "第9章 木構造" do
  describe "Algorithm::BinarySearchTree" do
    let(:bst) do
      tree = Algorithm::BinarySearchTree.new
      [5, 3, 7, 1, 4, 6, 8].each { |k| tree.insert(k) }
      tree
    end

    it "挿入と探索" do
      expect(bst.search(5)).not_to be nil
      expect(bst.search(5).key).to eq(5)
      expect(bst.search(99)).to be nil
    end

    it "include?" do
      expect(bst.include?(3)).to be true
      expect(bst.include?(99)).to be false
    end

    it "length" do
      expect(bst.length).to eq(7)
    end

    it "重複挿入は無視される" do
      bst.insert(5)
      expect(bst.length).to eq(7)
    end

    it "min と max" do
      expect(bst.min).to eq(1)
      expect(bst.max).to eq(8)
    end

    it "中順探索（昇順）" do
      expect(bst.inorder).to eq([1, 3, 4, 5, 6, 7, 8])
    end

    it "前順探索" do
      expect(bst.preorder).to eq([5, 3, 1, 4, 7, 6, 8])
    end

    it "後順探索" do
      expect(bst.postorder).to eq([1, 4, 3, 6, 8, 7, 5])
    end

    describe "delete" do
      it "葉ノードの削除" do
        bst.delete(1)
        expect(bst.include?(1)).to be false
        expect(bst.inorder).to eq([3, 4, 5, 6, 7, 8])
      end

      it "子が1つのノードの削除" do
        bst.delete(1)  # 葉を削除して3を子1つにする
        bst.delete(3)
        expect(bst.include?(3)).to be false
        expect(bst.inorder).to eq([4, 5, 6, 7, 8])
      end

      it "子が2つのノードの削除" do
        bst.delete(7)
        expect(bst.include?(7)).to be false
        expect(bst.inorder).to eq([1, 3, 4, 5, 6, 8])
      end

      it "ルートノードの削除" do
        bst.delete(5)
        expect(bst.include?(5)).to be false
        expect(bst.inorder).to eq([1, 3, 4, 6, 7, 8])
      end
    end

    it "空の木のminは例外" do
      empty_bst = Algorithm::BinarySearchTree.new
      expect { empty_bst.min }.to raise_error(Algorithm::BinarySearchTree::Empty)
    end
  end
end
