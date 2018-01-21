##
# spec/lib/lists/node_based_linked_list_spec.rb
#

RSpec.describe Lists::DoublyLinkedList, "DoublyLinkedList using node interface " do

  context "Node Interface Edge Cases " do
    let(:node) { described_class.call(10, 20, 30, 40, 50, 60, 60, 70, 80, 90, 100) {|a| a} }

    context "Node Retrieval " do

      it "#node_request(:first) returns a LinkedNode object." do
        expect(node.send(:node_request,:first)).to be_a Lists::LinkNode
      end
      it "#first_node returns a LinkedNode object." do
        expect(node.first_node).to be_a Lists::LinkNode
      end
      it "#next_node returns a LinkedNode object." do
        expect(node.next_node).to be_a Lists::LinkNode
      end
      it "#current_node returns a LinkedNode object." do
        expect(node.current_node).to be_a Lists::LinkNode
      end
      it "#prev_node returns a LinkedNode object." do
        expect(node.prev_node).to be_a Lists::LinkNode
      end
      it "#last_node returns a LinkedNode object." do
        expect(node.last_node).to be_a Lists::LinkNode
      end
    end

    context "Node Values " do

      it "#methods with params are supported through #{}node_request() interface. " do
        expect(node.first_node.node_value_request(:at_index, 5)).to eq(50)
      end
      it "First node has the expected value. " do
        expect(node.first_node.value).to eq(10)
      end
      it "Next node has the expected value. " do
        expect(node.next_node.value).to eq(20)
      end
      it "Current node has the expected value. " do
        3.times { node.next_node }
        expect(node.current_node.value).to eq(40)
      end
      it "Last node has the expected value. " do
        expect(node.last_node.value).to eq(100)
      end
      it "#node_value collected match #to_a output. " do
        nav_ary = []
        node.node_value_request(:size).times do
          nav_ary << node.node_value
          node.next_node
        end

        expect(nav_ary).to eq(node.node_value_request(:to_a))
        expect(nav_ary).to eq([10, 20, 30, 40, 50, 60, 60, 70, 80, 90, 100])
      end
    end

    context "Node Navigation " do

      it "Can navigate to each mode in list, forward. " do
        node.node_value_request(:size).times do
          expect(node.next_node).to be_a Lists::LinkNode
        end
      end
      it "Can navigate to each mode in list, backward. " do
        node.last_node.node_value_request(:size).times do
          expect(node.prev_node).to be_a Lists::LinkNode
        end
      end
      it "Values collected match #to_a output. " do
        nav_ary = []
        node.node_value_request(:size).times do
          nav_ary << node.node_value
          node.next_node
        end

        expect(node.node_value_request(:to_a)).to eq(nav_ary)
      end
    end
  end

end
