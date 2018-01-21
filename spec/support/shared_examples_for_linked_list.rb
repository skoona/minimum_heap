
RSpec.shared_examples "a linked list" do |list_type|

  context "Initialization" do
    it "can be initialized without params" do
      expect(subject).to be
    end
    it "can insert the first value" do
      expect(subject.empty?).to be true
      expect(subject.insert(101)).to eq(1)
    end
    it "can be cleared" do
      subject.insert(101)
      expect(subject.clear).to eq(1)
    end
    it "can be initialized with one or more initial values" do
      list = described_class.new(10,100,100)
      expect(list.size).to eq(3)
    end
    it "positions to first element after being initialized with multiple values" do
      list = described_class.new(10, 100, 1000)
      expect(list.current).to eq(10)
    end
    it "can not be initialized with any array as the single value." do
      list = described_class.new([10, 100, 1000])
      expect(list.current).to eq([10, 100, 1000])
      expect(list.size).to eq(1)
    end
    it { is_expected.to be_empty }
  end

  context "Navigation" do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

    it "#first returns the first value" do
      expect(list.first).to eq(10)
    end
    it "#next returns the second value" do
      expect(list.next).to eq(20)
    end
    it "#current returns the last value accessed" do
      expect(list.current).to eq(10)
      expect(list.next).to eq(20)
      expect(list.current).to eq(20)
    end
    it "#last returns the last value" do
      expect(list.last).to eq(100)
    end
    it "#nth(6) returns the sixth value" do
      expect(list.nth(6)).to eq(60)
    end
    it "#at_index(6) returns the sixth value" do
      expect(list.at_index(6)).to eq(60)
    end
  end

  context "Insertions" do
    it "#insert(value) indicates a value was added" do
      bsize = subject.size
      expect(subject.insert(110)).to eq(bsize + 1)
    end
    it "#prepend(value) indicates a value was added" do
      bsize = subject.size
      expect(subject.prepend(110)).to eq(bsize + 1)
    end
    it "#append(value) indicates a value was added" do
      bsize = subject.size
      expect(subject.append(110)).to eq(bsize + 1)
    end
    it "#insert_before(pvalue,value) indicates a value was added" do
      subject.insert(120)
      bsize = subject.size
      expect(subject.insert_before(120, 110)).to eq(bsize + 1)
      expect(subject.to_a).to eq([110,120])
    end
    it "#insert_after(pvalue, value) indicates a value was added" do
      subject.insert(120)
      bsize = subject.size
      expect(subject.insert_after(120, 125)).to eq(bsize + 1)
      expect(subject.to_a).to eq([120,125])
    end
  end

  context "Removals" do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

    it "#remove(value) removes first occurance of that value" do
      bsize = list.size
      expect(list.remove(30)).to eq(bsize - 1)
      expect(list.to_a).to eq([10,20, 40, 50, 60, 70, 80, 90, 100])
    end
    it "#clear removes all elements from list" do
      expect(list.clear).to eq(10)
      expect(list.empty?).to be true
    end
  end

  context "Enumeration" do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

    it "#each works as expected when block is provided" do
      x = []
      list.each {|r| x << r}
      expect(x).to be_a(Array)
      expect(x).to eq([10,20, 30, 40, 50, 60, 70, 80, 90, 100])
    end
    it "#each works as expected when no block is offered" do
      base = list.each
      expect(base).to be_a(Enumerator)
      8.times { base.next }
      expect(base.next).to eq(90)
    end
    it "#to_a returns the contents of linkedlist as an Array" do
      base = list.to_a
      expect(base).to be_a(Array)
      expect(base).to eq([10,20, 30, 40, 50, 60, 70, 80, 90, 100])
    end
  end

  context "Sort Feature" do
    let(:num_list)   { described_class.new(100, 50, 10, 40, 80, 30, 60, 90, 70, 20, 110) }
    let(:alpha_list) { described_class.new('Z', 'K', 'S', 'n', 's', 'z', 'k', 'N', 'o', 'A') }
    let(:hash_list)  { described_class.new({key: 'Z'}, {key: 'K'}, {key: 'S'}, {:key=>"S"}, {key: 'n'}, {key: 's'},
                                           {key: 'z'}, {key: 'k'}, {key: 'N'}, {key: 'A'}
                                          ) {|a| a[:key]}
    }

    it "#sort! redefines numeric list in asending order" do
      expect(num_list.sort!).to eq(11)
      expect(num_list.to_a).to eq([10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110])
    end
    it "#sort!(:desc) redefines numeric list in descending order" do
      expect(num_list.sort!(:desc)).to eq(11)
      expect(num_list.to_a).to eq([110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10])
    end
    it "#sort! redefines alpha numeric list in asending order" do
      expect(alpha_list.sort!).to eq(10)
      expect(alpha_list.to_a).to eq(["A", "K", "N", "S", "Z", "k", "n", "o", "s", "z"])
    end
    it "#sort!(:desc) redefines alpha numeric list in descending order" do
      expect(alpha_list.sort!(:desc)).to eq(10)
      expect(alpha_list.to_a).to eq(["z", "s", "o", "n", "k", "Z", "S", "N", "K", "A"])
    end
    it "#sort!() redefines hash object values in default order" do
      expect(hash_list.sort!).to eq(10)
      expect(hash_list.to_a).to eq([{:key=>"A"}, {:key=>"K"}, {:key=>"N"}, {:key=>"S"}, {:key=>"S"}, {:key=>"Z"},
                                    {:key=>"k"}, {:key=>"n"}, {:key=>"s"}, {:key=>"z"}])
    end
    it "#sort!() lambda overrides sort_condifiton and sorts hash object values in custom order" do
      expect(hash_list.sort!() {|a,b| a[:key] <= b[:key] }).to eq(10)
      expect(hash_list.to_a).to eq([{:key=>"z"}, {:key=>"s"}, {:key=>"n"}, {:key=>"k"},
                                    {:key=>"Z"}, {:key=>"S"}, {:key=>"S"}, {:key=>"N"}, {:key=>"K"}, {:key=>"A"}])
    end
  end

end