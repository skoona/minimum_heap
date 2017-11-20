##
# File: <root>/lib/heaps/empty_node.rb
##

# Avoids nil checks
module Heaps

  class EmptyNode
    def initialize(*)
    end

    def value
      -1
    end

    def label
      self.class.name
    end

    def data
      {label: label, value: value}
    end

    def data=(*)
      nil
    end

    def to_s
      data
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

    def insert_node(*)
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

    def move_down
      self
    end

    end
end