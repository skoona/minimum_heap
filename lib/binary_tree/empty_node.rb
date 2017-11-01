##
# File: <root>/lib/binary_tree/empty_node.rb
##


module BinaryTree

  class EmptyNode
    def to_a
      []
    end

    def include?(*)
      false
    end

    def push(*)
      false
    end
    alias_method :<<, :push

    def inspect
      "{}"
    end
  end

end