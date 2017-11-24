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

    def description
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

    def valid?
      false
    end

    def data
      {description: description, value: value}
    end

    def data=(*)
      nil
    end

    def include?(*)
      false
    end

    def insert_node(*)
      false
    end

    def move_down
      nil
    end

    def swap_contents(*)
      nil
    end

    def clean(*)
      nil
    end

    def to_s
      data
    end

    def inspect(*)
      "{}"
    end

    def dfs_pre_order(*)
      []
    end

    def <(*)
      false
    end

    def >(*)
      false
    end

    def ==(*)
      false
    end
    alias_method  :eql?, :==

    def <=>(*)
      nil
    end

    end
end