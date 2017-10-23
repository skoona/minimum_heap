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

    private

    def insert_left(node)
      left.insert(node) or self.left = node
    end

    def insert_right(node)
      right.insert(node) or self.right = node
    end

  end
end
