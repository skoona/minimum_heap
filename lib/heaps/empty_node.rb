##
# File: <root>/lib/heaps/empty_node.rb

# Avoids nil checks
module Heaps

  class EmptyNode
    def value
      -1
    end

    def title
      self.class.name
    end

    def left(*)
      false
    end

    def right(*)
      false
    end

    def parent(*)
      false
    end

    def insert(*)
      false
    end

    def include?(*)
      false
    end

    def valid?
      false
    end

    def to_a
      []
    end

    def inspect(*)
      "{}"
    end

    def <=>(*)
      nil
    end

    end
end