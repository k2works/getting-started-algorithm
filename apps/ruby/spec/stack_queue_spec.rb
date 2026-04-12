# frozen_string_literal: true

require "algorithm/stack_queue"

RSpec.describe "第4章 スタックとキュー" do
  describe "Algorithm::FixedStack" do
    let(:stack) { Algorithm::FixedStack.new(5) }

    it "プッシュ・ポップ" do
      stack.push(1)
      stack.push(2)
      stack.push(3)
      expect(stack.pop).to eq(3)
      expect(stack.pop).to eq(2)
    end

    it "peek" do
      stack.push(1)
      stack.push(2)
      expect(stack.peek).to eq(2)
      expect(stack.length).to eq(2)
    end

    it "空のスタックからのポップは例外" do
      expect { stack.pop }.to raise_error(Algorithm::FixedStack::Empty)
    end

    it "満杯のスタックへのプッシュは例外" do
      5.times { |i| stack.push(i) }
      expect { stack.push(99) }.to raise_error(Algorithm::FixedStack::Full)
    end

    it "find" do
      stack.push(10)
      stack.push(20)
      stack.push(30)
      expect(stack.find(20)).to eq(1)
      expect(stack.find(99)).to eq(-1)
    end

    it "count" do
      stack.push(1)
      stack.push(2)
      stack.push(1)
      expect(stack.count(1)).to eq(2)
    end

    it "include?" do
      stack.push(42)
      expect(stack.include?(42)).to be true
      expect(stack.include?(99)).to be false
    end

    it "clear" do
      stack.push(1)
      stack.clear
      expect(stack.empty?).to be true
    end
  end

  describe "Algorithm::FixedQueue" do
    let(:queue) { Algorithm::FixedQueue.new(5) }

    it "エンキュー・デキュー" do
      queue.enque(1)
      queue.enque(2)
      queue.enque(3)
      expect(queue.deque).to eq(1)
      expect(queue.deque).to eq(2)
    end

    it "peek" do
      queue.enque(1)
      queue.enque(2)
      expect(queue.peek).to eq(1)
      expect(queue.length).to eq(2)
    end

    it "空のキューからのデキューは例外" do
      expect { queue.deque }.to raise_error(Algorithm::FixedQueue::Empty)
    end

    it "満杯のキューへのエンキューは例外" do
      5.times { |i| queue.enque(i) }
      expect { queue.enque(99) }.to raise_error(Algorithm::FixedQueue::Full)
    end

    it "リングバッファとして動作する" do
      3.times { |i| queue.enque(i) }
      2.times { queue.deque }
      3.times { |i| queue.enque(i + 10) }
      expect(queue.deque).to eq(2)
      expect(queue.deque).to eq(10)
    end

    it "find" do
      queue.enque(10)
      queue.enque(20)
      queue.enque(30)
      expect(queue.find(20)).to eq(1)
      expect(queue.find(99)).to eq(-1)
    end

    it "count" do
      queue.enque(1)
      queue.enque(2)
      queue.enque(1)
      expect(queue.count(1)).to eq(2)
    end

    it "clear" do
      queue.enque(1)
      queue.clear
      expect(queue.empty?).to be true
    end
  end
end
