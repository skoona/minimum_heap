##
# File: <root>/lib/heaps/node.rb

# Primary Tree Node
module Heaps

  class  Node
    attr_reader   :title, :value
    attr_accessor :left,  :right, :parent

    def initialize(title, value)
      @title  = title
      @value = value
      @left   = EmptyNode.new
      @right  = EmptyNode.new
      @parent = EmptyNode.new
    end

    def swap_contents(node)
      old = {title: title, value: value}
      self.title = node.title
      self.value = node.value
      node.title = old[:title]
      node.value = old[:value]
      nil
    end

    def valid?
      true
    end

    def insert_node(node)
      puts "#{__method__}(#{node.value}) Inserted #{left ? 'Right' : 'Left'} ..."
      left ? insert_right(node) : insert_left(node)
    end

    def include?(this_value)
      case this_value.class
        when String
          case title <=> this_value
            when 1 then left.include?(this_value)
            when -1 then right.include?(this_value)
            when 0 then true # the current node is equal to the value
          end
        else
          case value <=> this_value
            when 1 then left.include?(this_value)
            when -1 then right.include?(this_value)
            when 0 then true # the current node is equal to the value
          end
      end
    end


    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

    def to_a
      left.to_a + [{title: self.title.dup, value: self.value.dup}] + right.to_a
    end

    def <=>(other)
      if self.value > other.value
        1
      elsif self.value < other.value
        -1
      elsif self.value == other.value
        0
      else
        nil
      end
    end

    private

    def insert_left(node)
      puts "#{__method__}(#{node.value})..."
      self.left = node; node.parent = self
    end

    def insert_right(node)
      puts "#{__method__}(#{node.value})..."
      self.right = node; node.parent = self
    end

    def swap_up(node)
      puts "#{__method__}..."
      return if node.value < node.parent.value

      node_parent = node.parent
      node_parent_left = node_parent.left
      node_parent_right = node_parent.right

      node_parent.parent = node
      node_parent.left = node.left
      node_parent.right = node.right

      node.parent = node_parent
      node.left = node_parent_left unless node_parent_left == node
      node.right = node_parent_right unless node_parent_right == node
    end

    def node_swap_up(node)
      puts "#{__method__}..."
      parent_node = node.parent
      # unless pacific rim is nil || pacific rim's rating <= braveheart's rating -> 72 <= 78
      unless !parent_node.valid? || parent_node.value <= node.value
        # Handle the parents
        grandparent = parent_node.parent
        parent_node.parent = node
        node.parent = grandparent

        # Handle the lefts
        node_left = node.left

        unless !grandparent.valid?
          grandparent.left = node
        else
          @root = node
        end

        node.left = parent_node
        parent_node.left = node_left

        # Hangle the rights
        node_right = node.right

        unless !grandparent.valid?
          grandparent.right = node
          node.right = parent_node
        else
          node.right = parent_node.right # this line is wrong for GP case
        end
        parent_node.right = node_right
      end
    end


  end
end
