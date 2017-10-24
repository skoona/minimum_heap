
require "spec_helper"

RSpec.describe Heaps::MinimumHeap, type: Class do
  let (:root) { Heaps::Node.new("The Matrix", 87) }

  let (:tree) { Heaps::MinimumHeap.new(root) }
  let (:node1) { Heaps::Node.new("Pacific Rim", 72) }
  let (:node2) { Heaps::Node.new("Braveheart", 78) }
  let (:node3) { Heaps::Node.new("Star Wars: Return of the Jedi", 80) }
  let (:node4) { Heaps::Node.new("Donnie Darko", 85) }
  let (:node5) { Heaps::Node.new("Inception", 86) }
  let (:node6) { Heaps::Node.new("District 9", 90) }
  let (:node7) { Heaps::Node.new("The Shawshank Redemption", 91) }
  let (:node8) { Heaps::Node.new("The Martian", 92) }
  let (:node9) { Heaps::Node.new("Star Wars: A New Hope", 93) }
  let (:node10) { Heaps::Node.new("Star Wars: The Empire Strikes Back", 94) }
  let (:node11) { Heaps::Node.new("Mad Max 2: The Road Warrior", 98) }

  it "has a version number" do
    expect(Heaps::VERSION).not_to be nil
  end

  context "#insert(data)" do
    before :each do
      @tree = Heaps::MinimumHeap.new(root)
    end
    
    it "properly inserts a new node as a left-right child" do
      @tree.insert(node4) #85
      @tree.insert(node5) #86
      @tree.insert(node6) #90
      @tree.insert(node2) #78
      @tree.insert(node9) #91
      puts @tree.root.inspect
      expect(@tree.root.rating).to eq 78
      expect(@tree.root.left.rating).to eq 85
      expect(@tree.root.right.rating).to eq 86
      expect(@tree.root.left.left.rating).to eq 87
      expect(@tree.root.left.right.rating).to eq 90
    end

    it "properly inserts a new node as a right-left child" do
      @tree.insert( node9) #93
      @tree.insert( node8) #92
      @tree.insert( node2) #78
      @tree.insert( node5) #86
      @tree.insert( node11) #98
      expect(@tree.root.rating).to eq 78
      expect(@tree.root.left.rating).to eq 86
      expect(@tree.root.right.rating).to eq 92
      expect(@tree.root.left.left.rating).to eq 93
      expect(@tree.root.left.right.rating).to eq 87
      expect(@tree.root.right.left.rating).to eq 98
    end
  end

  context "#find(data)" do
    before :each do
      @tree = Heaps::MinimumHeap.new(root)
    end

    it "properly finds a left-right node" do
      @tree.insert( node2) #78
      @tree.insert( node4) #85
      @tree.insert( node5) #86
      @tree.insert( node6) #90
      expect(@tree.find(root, node6.rating).rating).to eq 90
    end

    it "properly finds a right-left node" do
      @tree.insert( node2) #78
      @tree.insert( node5) #86
      @tree.insert( node11) #98
      @tree.insert( node9) #93
      @tree.insert( node8) #92
      expect(@tree.find(root, node8.rating).rating).to eq 92
    end
  end

  context "#delete(data)" do
    before :each do
      @tree = Heaps::MinimumHeap.new(root)
    end

    it "properly deletes a left-right node" do
      @tree.insert( node6) #90
      @tree.insert( node2) #78
      @tree.insert( node4) #85
      @tree.insert( node5) #86
      @tree.delete(root, node5.rating)
      expect(@tree.find(root, node5.rating).rating).to be_nil
    end

    it "properly deletes a right-left node" do
      @tree.insert( node9) #93
      @tree.insert( node8) #92
      @tree.insert( node2) #78
      @tree.insert( node5) #86
      @tree.insert( node11) #98
      @tree.delete(root, node11.rating)
      expect(@tree.find(root, node11.rating).rating).to be_nil
    end
  end

  context "#display_tree" do
    before :each do
      @tree = Heaps::MinimumHeap.new(root)
    end

    specify {
      expected_output = "Pacific Rim: 72\nBraveheart: 78\nStar Wars: Return of the Jedi: 80\nThe Matrix: 87\nDistrict 9: 90\nStar Wars: The Empire Strikes Back: 94\nInception: 86\nStar Wars: A New Hope: 93\nThe Shawshank Redemption: 91\nThe Martian: 92\nMad Max 2: The Road Warrior: 98\n"
      @tree.insert( node9) #93
      @tree.insert( node10) #94
      @tree.insert( node3) #80
      @tree.insert( node8) #92
      @tree.insert( node1) #72
      @tree.insert( node5) #86
      @tree.insert( node2) #78
      @tree.insert( node7) #91
      @tree.insert( node6) #90
      @tree.insert( node11) #98
      expect { @tree.display_tree }.to output(expected_output).to_stdout
    }
  end
end
