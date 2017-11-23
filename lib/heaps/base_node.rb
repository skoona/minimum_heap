##
# File: <root>/lib/heaps/base_node.rb
#
# Benchmarking node to evaluate creation time compared to Node
##
module Heaps

  class  BaseNode
    attr_accessor :left, :right, :parent, :description, :value

    def initialize(text_description, data_value)
      @description  = text_description
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
      {description: description.dup, value: value.dup}
    end

    def to_s
      data
    end

    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

  end
end