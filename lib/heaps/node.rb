##
# File: <root>/lib/heaps/node.rb

# Primary Tree Node
module Heaps

  class  Node
    attr_accessor :left, :right, :parent, :label, :value

    def initialize(text_label, data_value)
      @label  = text_label
      @value  = data_value
      tmp = EmptyNode.new
      @left   = tmp
      @right  = tmp
      @parent = tmp
    end

    def valid?
      true
    end

    def insert_node(node)
      if left.valid?
        if right.valid?
          self
        else
          insert_right(node)
        end
      else
        insert_left(node)
      end
    end

    def include?(other_node)
      self.label == other_node.label &&
          self.value == other_node.value
    end

    def swap_contents(node)
      puts "#{__method__} Replace: #{self.data} with #{node.data}"
      old = self.data
      self.label = node.label
      self.value = node.value
      node.label = old[:label]
      node.value = old[:value]
      nil
    end

    def data
      {label: label.dup, value: value.dup}
    end

    def to_s
      data
    end

    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

    def to_a
      left.to_a + [self.data] + right.to_a
    end

    def <=>(other)
      if self.value > other.value
        1
      elsif self.value < other.value
        -1
      elsif self.value == other.value
        0
      else
        nil
      end
    end

    def ==(other)
      self.class === other and
          other.value == self.value and
          other.label == self.label
    end
    alias_method  :eql?, :==

    def hash
      self.label.hash ^ self.value.hash # XOR
    end

    private

    def insert_left(node)
      self.left = node
      node.parent = self
      node
    end

    def insert_right(node)
      self.right = node
      node.parent = self
      node
    end

  end
end
