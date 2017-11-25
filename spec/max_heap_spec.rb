
require "spec_helper"
require "heap_commons_examples"

RSpec.describe Heaps::MaxHeap, "Maximum Heap Implementation wihtout Array storage" do

  include_context "heap commons"

  context "Insert User Data " do

    it "#push maintains Heap Property across complete and balanced tree: structured." do
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
      exp_out = '{102:{101:{93:{90:{70:{}|{}}|{}}|{80:{}|{}}}|{92:{78:{}|{}}|{91:{}|{}}}}|{100:{94:{72:{}|{}}|{86:{}|{}}}|{99:{85:{}|{}}|{98:{}|{}}}}}'
      expect(tree.inspect).to eq(exp_out)
    end

    it "#push maintains Heap Property across complete and balanced tree: unstructured." do
      tree.push(node9)
      tree.push(node10)
      tree.push(node11)
      tree.push(node12)
      tree.push(node13)
      tree.push(node14)
      tree.push(node15)
      tree.push(node1)
      tree.push(node2)
      tree.push(node3)
      tree.push(node4)
      tree.push(node5)
      tree.push(node6)
      tree.push(node7)
      tree.push(node8)
      exp_out = '{102:{100:{98:{92:{70:{}|{}}|{}}|{72:{}|{}}}|{94:{78:{}|{}}|{80:{}|{}}}}|{101:{93:{85:{}|{}}|{86:{}|{}}}|{99:{90:{}|{}}|{91:{}|{}}}}}'
      expect(tree.inspect).to eq(exp_out)
    end

  end

  context "Heap Property Operations" do

    it "#node_path_navigation returns desired node. " do
      expect(heap_prop.peek[:value]).to eq(98)
      expect(heap_prop.size).to eq(6)
      expect( heap_prop.send(:node_path_navigation, 4, false).value ).to eq(70)
      expect(heap_prop.size).to eq(6)
    end

    it "#push will not overwrite existing node on new insert. " do
      expect(heap_prop.peek[:value]).to eq(98)
      expect(heap_prop.size).to eq(6)
      expect{ heap_prop.send(:insert_node_on_path, Heaps::Node.new(node4.first, node4.last), 4) }.to raise_error(ArgumentError)
      expect(heap_prop.size).to eq(6)
    end

    it "#maintains Heap Property for nodes added." do
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

      tree.push(node7)
      puts heap_prop.inspect

      expect(heap_prop.peek[:value]).to eq(98)
    end

    it "#maintains Heap Property for nodes removed." do
      expect(heap_prop.peek[:value]).to eq(98)
      expect(heap_prop.size).to eq(6)

      expect(heap_prop.pop[:value]).to eq(98)

      expect(heap_prop.peek[:value]).to eq(86)
      expect(heap_prop.size).to eq(5)
    end

    it "#pop remove nodes in descending order" do
      expected_array = [{:description=>"The Matrix", :value=>70, payload: {}}, {:description=>"Pacific Rim", :value=>72, payload: {}}, {:description=>"Star Wars: Return of the Jedi", :value=>80, payload: {}}, {:description=>"Donnie Darko", :value=>85, payload: {}}, {:description=>"Inception", :value=>86, payload: {}}, {:description=>"Mad Max 2: The Road Warrior", :value=>98, payload: {}}]
      actual_array = []
      while !heap_prop.empty? do
        actual_array << heap_prop.pop
      end
      expect(actual_array).to match_array expected_array
    end

    it "#replace! removes root node and immediately replaces it with this new node" do
      expect(heap_prop.peek[:value]).to eq(98)
      expect(heap_prop.size).to eq(6)

      expect(heap_prop.replace!(node15)[:value]).to eq(98)

      expect(heap_prop.peek[:value]).to eq(102)
      expect(heap_prop.size).to eq(6)
    end

    it "#clear! removes all nodes in heap" do
      expect(heap_prop.peek[:value]).to eq(98)
      expect(heap_prop.size).to eq(6)
      expect(heap_prop.empty?).to be false

      expect(heap_prop.clear!).to be_nil

      expect(heap_prop.empty?).to be true
      expect(heap_prop.size).to eq(0)
    end

    it "#include? finds requested node from array, hash, or node input. " do
      expect(heap_prop.include?(["Mad Max 2: The Road Warrior", 98], true)).to be_a(Heaps::Node)
      expect(heap_prop.include?({:description=>"Mad Max 2: The Road Warrior", :value=>98}, true)).to be_a(Heaps::Node)
      expect(heap_prop.include?(node11, true)).to be_a(Heaps::Node)
      expect(heap_prop.include?(node11)).to eq({:description=>"Mad Max 2: The Road Warrior", :value=>98, :payload=>{}})
    end

    it "#delete! removes node matching input user_data. " do
      expect(heap_prop.size).to eq(6)

      expect(heap_prop.delete!(["Mad Max 2: The Road Warrior", 98])).to eq({:description=>"Mad Max 2: The Road Warrior", :value=>98, payload: {}})

      expect(heap_prop.peek[:value]).to eq(86)
      expect(heap_prop.size).to eq(5)
    end

  end


end
