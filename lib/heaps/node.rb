##
# File: <root>/lib/heaps/node.rb

# Primary Tree Node
module Heaps

  class  Node
    attr_reader  :title, :rating, :left, :right, :parent

    def initialize(title, rating)
      @title  = title
      @rating = rating
      @left   = EmptyNode.new
      @right  = EmptyNode.new
      @parent = EmptyNode.new
    end

    def <=>(other)
      retun nil unless other.respond_to?(:rating)
      if self.rating > other.rating
        1
      elsif self.rating < other.rating
        -1
      elsif self.rating == other.rating
        0
      else
        nil
      end
    end

    def left=(value)
      @left = value.nil? ? EmptyNode.new : value
    end
    def right=(value)
      @right = value.nil? ? EmptyNode.new : value
    end
    def parent=(value)
      @parent = value.nil? ? EmptyNode.new : value
    end

    def insert(other)
      retun false unless other.respond_to?(:rating)
      case self <=> other
        when 1 then insert_left(other)
        when -1 then insert_right(other)
        else false # the value is already present
      end
    end

    def valid?
      true
    end

    def to_a
      left.to_a + [rating] + right.to_a
    end

    def include?(value)
      case rating <=> value
        when 1 then left.include?(value)
        when -1 then right.include?(value)
        when 0 then true # the current node is equal to the value
      end
    end

    def inspect
      "{#{rating}:#{left.inspect}|#{right.inspect}}"
    end

    private

    def insert_left(node)
      left.insert(node) || ( self.left = node; node.parent = self )
    end

    def insert_right(node)
      right.insert(node) || ( self.right = node; node.parent = self )
    end

  end
end
