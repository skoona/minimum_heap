require "spec_helper"

shared_context "heap commons" do

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
  let (:heap_prop) { heap_prop = described_class.new([node3, node4, node5, node11, root, node1]) }


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

    it "fails initialization via param list of values" do
      expect{described_class.new(root, node1, node2, node3, node4)}.to raise_error(ArgumentError)
    end

    it "initializes with array of values" do
      ary_values = [root, node1, node2, node3, node4]
      expect(described_class.new(ary_values)).to be
    end

    it "initializes with array of hash values" do
      hash_ary = [root, node1, node2, node3, node4].map {|x| {description: x.first, value: x.last} }
      expect(described_class.new(hash_ary)).to be
    end

    it "initializes with array of Nodes" do
      node_ary = [root, node1, node2, node3, node4].map {|x| Heaps::Node.new(x.first, x.last) }
      expect(described_class.new(node_ary)).to be
    end

    it "initializes with a simple params" do
      expect(described_class.new(["Star Trek: Next Generation", 102])).to be
    end

    it "tree can enable the debug log" do
      tree.instance_variable_set(:@output_log, true)
      expect{tree.pop}.to output(/Removing Node/).to_stdout
      tree.instance_variable_set(:@output_log, false)
      expect{tree.pop}.to_not output(/Removing Node/).to_stdout
    end

    it "tree will not accept an invalid node or user inlut" do
      expect( tree.push("some invalid stuff") ).to be_nil
      expect(tree.push(nil)).to be_nil
    end

  end

  context "Cover BaseNode " do
    before :each do
      @base = Heaps::BaseNode.new("Star Trek: Next Generation", 102)
    end

    it "BaseNode initializes" do
      expect(@base).to be
    end

    it "#description returns a value" do
      expect(@base.description).to be_a(String)
    end

    it "#value returns a value" do
      expect(@base.value).to be_a(Integer)
    end

    it "#valid? returns a value" do
      expect(@base.valid?).to be true
    end

    it "#to_s returns a value" do
      expect(@base.to_s).to be_a(Hash)
    end

    it "#inspect returns a value" do
      expect(@base.inspect).to be_a(String)
    end
  end

  context "Cover EmptyNode " do
    before :each do
      @enode = Heaps::EmptyNode.new("Star Trek: Next Generation", 102)
    end

    it "EmptyNode initializes" do
      expect(@enode).to be
    end

    it "#left returns false" do
      expect(@enode.left).to be false
    end

    it "#right returns false" do
      expect(@enode.right).to be false
    end

    it "#parent returns false" do
      expect(@enode.parent).to be false
    end

    it "#insert_node returns false" do
      expect(@enode.insert_node).to be false
    end

    it "#dfs_pre_order returns an empty array" do
      expect(@enode.dfs_pre_order).to be_a(Array)
    end
  end

  context "Cover Node " do
    before :each do
      @node = Heaps::Node.new("Star Trek: Next Generation", 102)
    end

    it "Node initializes" do
      expect(@node).to be
    end

    it "#<=> will detect equal" do
      expect(@node <=> @node).to eq(0)
    end

    it "#< will detect less than" do
      expect(@node < @node).to be false
    end
  end

  context "Heap Transforms " do

    it "#merge returns a new heap composed of this heap and other. " do
      hp1 = described_class.new([root, node1, node2, node3, node4])
      hp2 = described_class.new([node4, node5, node6, node7, node8])
      hp1_size = hp1.size
      hp2_size = hp2.size

      hp_merged = hp1.merge(hp2)

      expect(hp_merged).to be
      expect(hp_merged).to_not equal(hp1)
      expect(hp_merged.size).to eq(hp2_size + hp1_size - 1)
      expect(hp1.size).to eq(hp1_size)
      expect(hp2.size).to eq(hp2_size)
    end

    it "#merge! returns this heap after consuming other. " do
      hp1 = described_class.new([root, node1, node2, node3, node4])
      hp2 = described_class.new([node4, node5, node6, node7, node8])
      hp1_size = hp1.size
      hp2_size = hp2.size

      hp_merged = hp1.merge!(hp2)

      expect(hp_merged).to be
      expect(hp_merged).to equal(hp1)
      expect(hp2.size).to eq(hp2_size)
      expect(hp_merged.size).to eq(hp2_size + hp1_size)
    end

    it "#union returns new heap composed of this and other, destroying both source heaps. " do
      hp1 = described_class.new([root, node1])
      hp2 = described_class.new([node4, node5])
      hp1_size = hp1.size
      hp2_size = hp2.size

      hp_merged = hp1.union!(hp2)

      expect(hp_merged).to be
      expect(hp_merged).to_not equal(hp1)
      expect(hp_merged.size).to eq(hp2_size + hp1_size)
      expect(hp1.size).to eq(0)
      expect(hp2.size).to eq(0)
      expect(hp1.root).to be_a(Heaps::EmptyNode)
      expect(hp2.root).to be_a(Heaps::EmptyNode)
    end

    it "#to_a returns and array representing the current Minimum Heap. " do
      expect(heap_prop.to_a).to match_array [{:description=>"The Matrix", :value=>70}, {:description=>"Pacific Rim", :value=>72}, {:description=>"Star Wars: Return of the Jedi", :value=>80}, {:description=>"Donnie Darko", :value=>85}, {:description=>"Inception", :value=>86}, {:description=>"Mad Max 2: The Road Warrior", :value=>98}]
    end

    it "#display prints the user data of each node in the current Minimum Heap. " do
      expect(heap_prop.display).to match_array [{:description=>"The Matrix", :value=>70}, {:description=>"Pacific Rim", :value=>72}, {:description=>"Star Wars: Return of the Jedi", :value=>80}, {:description=>"Donnie Darko", :value=>85}, {:description=>"Inception", :value=>86}, {:description=>"Mad Max 2: The Road Warrior", :value=>98}]
    end
  end

end

# {:description=>"Mad Max 2: The Road Warrior", :value=>98}, {:description=>"Pacific Rim", :value=>72}, {:description=>"Star Wars: Return of the Jedi", :value=>80}, {:description=>"Donnie Darko", :value=>85}, {:description=>"The Matrix", :value=>70}, {:description=>"Inception", :value=>86}

# {:description=>"Star Trek: Next Generation", :value=>102}, {:description=>"The Matrix", :value=>70}, {:description=>"Pacific Rim", :value=>72}, {:description=>"Star Wars: Return of the Jedi", :value=>80}, {:description=>"Mad Max 2: The Road Warrior", :value=>98}, {:description=>"The Shawshank Redemption", :value=>91}, {:description=>"Donnie Darko", :value=>85}, {:description=>"Star Wars: A New Hope", :value=>93}, {:description=>"Star Wars: The Empire Strikes Back", :value=>94}, {:description=>"Braveheart", :value=>78}, {:description=>"Inception", :value=>86}, {:description=>"Star Trek: Voyager", :value=>100}, {:description=>"Star Trek: Star Trek", :value=>99}, {:description=>"District 9", :value=>90}, {:description=>"Star Trek: Deep Space 9", :value=>101}, {:description=>"The Martian", :value=>92}

