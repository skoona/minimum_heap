
require "spec_helper"

RSpec.describe Heaps::MinimumHeap, "Minimum Heap Implementation wihtout Array storage" do
  let (:root) { ["The Matrix", 70] }

  let (:node1) { ["Pacific Rim", 72] }
  let (:node2) { ["Braveheart", 78] }
  let (:node3) { ["Star Wars: Return of the Jedi", 80] }
  let (:node4) { ["Donnie Darko", 85] }
  let (:node5) { ["Inception", 86] }
  let (:node6) { ["District 9", 90] }
  let (:node7) { ["The Shawshank Redemption", 91] }
  let (:node8) { ["The Martian", 92] }
  let (:node9) { ["Star Wars: A New Hope", 93] }
  let (:node10) { ["Star Wars: The Empire Strikes Back", 94] }
  let (:node11) { ["Mad Max 2: The Road Warrior", 98] }

  let (:node12) { ["Star Trek: Star Trek", 99] }
  let (:node13) { ["Star Trek: Voyager", 100] }
  let (:node14) { ["Star Trek: Deep Space 9", 101] }
  let (:node15) { ["Star Trek: Next Generation", 102] }

  let (:tree) { described_class.new(root) }

  context "Initialization " do
    it "has a version number" do
      expect(Heaps::VERSION).not_to be nil
    end

    it "initializes without a root value" do
      expect(described_class.new).to be
    end

    it "initializes with a root values" do
      expect(described_class.new(root)).to be
    end

    it "initializes with param list of values" do
      expect(described_class.new(root, node1, node2, node3, node4)).to be
    end

    it "initializes with array of values" do
      ary_values = [root, node1, node2, node3, node4]
      expect(described_class.new(ary_values)).to be
    end

    it "initializes with array of hash values" do
      hash_ary = [root, node1, node2, node3, node4].map {|x| {label: x.first, value: x.last} }
      expect(described_class.new(hash_ary)).to be
    end
  end

  context "Inserting User Data " do

    it "#push maintains a completed and balanced tree." do
      tree.push(node1)
      tree.push(node2)
      tree.push(node3)
      tree.push(node4)
      tree.push(node5)
      tree.push(node6)
      tree.push(node7)
      tree.push(node8)
      tree.push(node9)
      tree.push(node10)
      tree.push(node11)
      tree.push(node12)
      tree.push(node13)
      tree.push(node14)
      tree.push(node15)
      exp_out = '{70:{72:{80:{91:{102:{}|{}}|{}}|{92:{}|{}}}|{85:{93:{}|{}}|{94:{}|{}}}}|{78:{86:{98:{}|{}}|{99:{}|{}}}|{90:{100:{}|{}}|{101:{}|{}}}}}'
      expect(tree.inspect).to eq(exp_out)
      puts tree.inspect
    end

    it "properly pushs a new node as a right-left child" do
      tree.push( node9) #93
      tree.push( node8) #92
      tree.push( node2) #78
      tree.push( node5) #86
      tree.push( node11) #98
      puts tree.to_a
    end
  end

  context "Creation api" do
    it "#merge returns a new heap composed of this heap and other. " do
      hp1 = described_class.new([root, node1, node2, node3, node4])
      hp2 = described_class.new(node4, node5, node6, node7, node8)
      hp1_size = hp1.size
      hp2_size = hp2.size
      hp_merged = hp1.merge(hp2)
      expect(hp_merged).to be
      expect(hp_merged).to_not equal(hp1)
      expect(hp_merged.size).to eq(hp2_size + hp1_size - 1)
    end

    it "#merge! returns this heap after consuming other. " do
      hp1 = described_class.new([root, node1, node2, node3, node4])
      hp2 = described_class.new(node4, node5, node6, node7, node8)
      hp1_size = hp1.size
      hp2_size = hp2.size
      hp_merged = hp1.merge!(hp2)
      expect(hp_merged).to be
      expect(hp_merged).to equal(hp1)
      expect(hp_merged.size).to eq(hp2_size + hp1_size)
    end

    it "#merge destroys this heap and other after creating a new combined heap. " do
      hp1 = described_class.new(root, node1)
      hp2 = described_class.new(node4, node5)
      hp1_size = hp1.size
      hp2_size = hp2.size
      hp_merged = hp1.merge(hp2)
      expect(hp_merged).to be
      expect(hp_merged).to_not equal(hp1)
      expect(hp_merged.size).to eq(hp2_size + hp1_size)
      expect(hp1.size).to eq(0)
      expect(hp2.size).to eq(0)
      expect(hp1.root).to be_nil
      expect(hp2.root).to be_nil
    end

  end

  context "Heap Property Operations" do
    it "#move_up retores heap property for nodes added." do
      heap_prop = described_class.new(node3)
      puts heap_prop.inspect

      heap_prop.push(node4)
      puts heap_prop.inspect

      heap_prop.push(node5)
      puts heap_prop.inspect

      heap_prop.push(node11)
      puts heap_prop.inspect

      heap_prop.push(root)
      puts heap_prop.inspect

      heap_prop.push(node1)
      puts heap_prop.inspect

      # puts heap_prop.inspect
      expect(heap_prop.peek[:value]).to eq(70)
      puts heap_prop.to_a
    end
  end

end
