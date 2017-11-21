##
# File: <root>/lib/heaps/base_node.rb
#
# Benchmarking node to evaluate creation time compared to Node
##
module Heaps

  class  BaseNode
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
      @value != nil
    end

    def data
      {label: label.dup, value: value.dup}
    end

    def data=(other_hash)
      self.label = other_hash[:label]
      self.value = other_hash[:value]
      nil
    end


    ##
    # Optional
    ##

    def to_s
      data
    end

    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

    def <=>(other)
      if value > other.value
        1
      elsif value < other.value
        -1
      elsif value == other.value
        0
      else
        nil
      end
    end

    def <(other)
      (self <=> other) < 0
    end

    def >(other)
      (self <=> other) > 0
    end

    def ==(other)
      self.class === other and hash == other.hash
    end
    alias_method  :eql?, :==

    def hash
      label.hash ^ value.hash # XOR
    end

  end
end