##
# File: <root>/lib/binary_tree/node.rb
##

# https://zvkemp.github.io/blog/2014/04/25/binary-search-trees-in-ruby/

module BinaryTree

  class Node
    # our three features:
    attr_reader :value
    attr_accessor :left, :right

    def initialize(v)
      @value = v
      @left = EmptyNode.new
      @right = EmptyNode.new
    end

    def push(v)
      case value <=> v
      when 1 then push_left(v)
      when -1 then push_right(v)
      when 0 then false # the value is already present
      end
    end
    alias_method :<<, :push

    def include?(v)
      case value <=> v
      when 1 then left.include?(v)
      when -1 then right.include?(v)
      when 0 then true # the current node is equal to the value
      end
    end

    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

    def to_a
      left.to_a + [value] + right.to_a
    end

    private

      def push_left(v)
        left.push(v) or self.left = Node.new(v)
      end

      def push_right(v)
        right.push(v) or self.right = Node.new(v)
      end
  end
end
