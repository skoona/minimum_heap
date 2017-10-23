##
# File: <root>/lib/heaps/empty_node.rb

# Avoids nil checks
module Heaps

  class EmptyNode
    def rating
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

    def <=>(other)
      nil
    end

    def insert(*)
      false
    end

    def valid?
      false
    end
    def to_a
      []
    end

    def include?(*)
      false
    end

    def inspect(*)
      "{}"
    end
  end
end