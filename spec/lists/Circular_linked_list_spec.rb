##
# spec/lib/lists/circular_linked_list_spec.rb
#

require "support/shared_examples_for_linked_list"

RSpec.describe Lists::CircularLinkedList, "Circular LinkedList " do

  it_behaves_like "a linked list", 'circular'

  context "CircularLinkedList Specific" do

    context "Navigation" do
      let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

      it "#prev returns the prior value" do
        expect(list.prev).to eq(100)
      end
      it "#nth(6) returns the sixth value" do
        expect(list.nth(6)).to eq(60)
        expect(list.nth(-2)).to eq(40)
      end
      it "#at_index(6) returns the sixth value" do
        expect(list.at_index(6)).to eq(60)
      end
    end

    context "Edge cases " do
      let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

      it "#at_index(-999) fails and returns the current element. " do
        expect(list.at_index(-999)).to eq(10)
      end
      it "#at_index(0) fails and returns the current element. " do
        expect(list.at_index(0)).to eq(10)
      end
      it "#at_index(999) fails and returns the current element. " do
        expect(list.at_index(999)).to eq(10)
      end
      it "#at_index(n) returns the proper element. " do
        expect(list.at_index(1)).to eq(10)
        expect(list.at_index(list.size / 2)).to eq(50)
        expect(list.at_index(list.size)).to eq(100)
      end
      it "#at_index(n) returns the proper element for linkedlist with one element. " do
        only = described_class.new(55)
        expect(only.at_index(1)).to eq(55)
        expect(only.at_index(2)).to eq(55)
        expect(only.at_index(10)).to eq(55)
      end

      it "#nth(-999) fails and returns current value." do
        expect(list.nth(-999)).to eq(10)
      end
      it "#nth(0) fails and returns current value." do
        expect(list.nth(0)).to eq(10)
      end
      it "#nth(999) fails and returns current value." do
        expect(list.nth(999)).to eq(10)
      end

      it "#current equals first initialization value." do
        expect(list.current).to eq(10)
      end
      it "#next after initialization returns correctly. " do
        expect(list.next).to eq(20)
        expect(list.next).to eq(30)
        expect(list.next).to eq(40)
      end
      it "#prev after first returns proper sequence of values. " do
        expect(list.first).to eq(10)
        expect(list.prev).to eq(100)
        expect(list.prev).to eq(90)
      end

      it "#first, #next, #current, #prev, #nth, and #last return same value when size == 1. " do
        only = described_class.new(55)
        expect(only.first).to eq(55)
        expect(only.next).to eq(55)
        expect(only.prev).to eq(55)
        expect(only.last).to eq(55)
        expect(only.current).to eq(55)
        expect(only.nth(2)).to eq(55)
        expect(only.at_index(2)).to eq(55)
      end
      it "#first, #next, #current, #prev, #nth, and #last return nil value when size == 0. " do
        only = described_class.new
        expect(only.first).to be nil
        expect(only.next).to be nil
        expect(only.prev).to be nil
        expect(only.last).to be nil
        expect(only.current).to be nil
        expect(only.nth(2)).to be nil
        expect(only.at_index(2)).to be nil
      end
      it "#prepend enables navigation methods normal operations. " do
        only = described_class.new
        only.prepend(55)
        expect(only.first).to eq(55)
        expect(only.next).to eq(55)
        expect(only.prev).to eq(55)
        expect(only.last).to eq(55)
        expect(only.current).to eq(55)
        expect(only.nth(2)).to eq(55)
        expect(only.at_index(2)).to eq(55)
      end
      it "#append enables navigation methods normal operations. " do
        only = described_class.new
        only.append(55)
        expect(only.first).to eq(55)
        expect(only.next).to eq(55)
        expect(only.prev).to eq(55)
        expect(only.last).to eq(55)
        expect(only.current).to eq(55)
        expect(only.nth(2)).to eq(55)
        expect(only.at_index(2)).to eq(55)
      end
      it "#insert_before enables navigation methods normal operations. " do
        only = described_class.new
        only.insert_before(nil, 55)
        expect(only.first).to eq(55)
        expect(only.next).to eq(55)
        expect(only.prev).to eq(55)
        expect(only.last).to eq(55)
        expect(only.current).to eq(55)
        expect(only.nth(2)).to eq(55)
        expect(only.at_index(2)).to eq(55)
      end
      it "#insert_after enables navigation methods normal operations. " do
        only = described_class.new
        only.insert_after(nil, 55)
        expect(only.first).to eq(55)
        expect(only.next).to eq(55)
        expect(only.prev).to eq(55)
        expect(only.last).to eq(55)
        expect(only.current).to eq(55)
        expect(only.nth(2)).to eq(55)
        expect(only.at_index(2)).to eq(55)
      end
      it "#remove does not make navigation methods unstable when removing 2:2. " do
        only = described_class.new(55,60)
        only.remove(60)
        expect(only.first).to eq(55)
        expect(only.next).to eq(55)
        expect(only.last).to eq(55)
        expect(only.current).to eq(55)
        expect(only.nth(2)).to eq(55)
        expect(only.at_index(2)).to eq(55)
      end
      it "#remove does not make navigation methods unstable when removing 1:2. " do
        only = described_class.new(55,60)
        only.remove(55)
        expect(only.first).to eq(60)
        expect(only.next).to eq(60)
        expect(only.last).to eq(60)
        expect(only.current).to eq(60)
        expect(only.nth(2)).to eq(60)
        expect(only.at_index(2)).to eq(60)
      end
      it "#remove does not make navigation methods unstable if empty?. " do
        only = described_class.new(55)
        only.remove(55)
        expect(only.first).to be nil
        expect(only.next).to be nil
        expect(only.last).to be nil
        expect(only.current).to be nil
        expect(only.nth(2)).to be nil
        expect(only.at_index(2)).to be nil
      end
      it "#remove does not make navigation methods unstable when target not found. " do
        only = described_class.new(55)
        only.remove(20)
        expect(only.to_a).to eq([55])
        expect(only.first).to eq(55)
        expect(only.next).to eq(55)
        expect(only.last).to eq(55)
        expect(only.current).to eq(55)
        expect(only.nth(2)).to eq(55)
        expect(only.at_index(2)).to eq(55)
      end
    end
  end

end
