##
# File: <root>/lib/heaps/node.rb

# Primary Tree Node
module Heaps

  class  Node
    attr_accessor :left, :right, :parent, :label, :value

    def initialize(text_label, data_value)
      @label  = text_label
      @value  = data_value
      tmp = EmptyNode.new
      @left   = tmp
      @right  = tmp
      @parent = tmp
    end

    def valid?
      !@value.nil?
    end

    def data
      {label: label.dup, value: value.dup}
    end

    def data=(other_hash)
      self.label = other_hash[:label]
      self.value = other_hash[:value]
      nil
    end
        
    # Returns self(found matching node) or nil
    def include?(other_node)
      (self == other_node ? self : nil) ||
          left.include?(other_node) ||
            right.include?(other_node)
    end

    # Insert here
    def insert_node(node)
      if left.valid?
        if right.valid?
          self
        else
          insert_right(node)
        end
      else
        insert_left(node)
      end
    end

    # Heap Property: The value of parent is smaller than that of either child
    # - and both subtrees have the heap property.
    # Side Effect: returns last node in tree
    def move_down
      nleft = nil
      nright = nil

      if left.valid? and self > left                 # Must be more than parent:
        swap_contents(left)
      end

      if right.valid? and left > right              # Must be less than right child:
        left.swap_contents(right)
      end

      nleft  = left.move_down  if left.valid?
      nright = right.move_down if right.valid?

      nright || nleft || self                      # side effect: Returns Last Inserted Node
    end

    def swap_contents(node)
      old = data
      self.data = node.data
      node.data = old
      self
    end

    def clean(children=false)
      if children
        left&.valid?  ? left.clean(children) : nil
        right&.valid? ? right.clean(children) : nil
      end
      self.label = nil
      self.value = nil
      self.left = nil
      self.right = nil
      if parent&.valid?                 # TODO: Ruby 2.4 feature 'obj&.method' nil safe
        if parent.left == self          # uncouple last node from tree
          parent.left = EmptyNode.new
        end
        if parent.right == self
          parent.right = EmptyNode.new
        end
      end
      self.parent = nil
      self
    end

    # Use PreOrder method to search Tree
    # - Supporting #to_a
    # https://medium.freecodecamp.org/all-you-need-to-know-about-tree-data-structures-bceacb85490c
    def dfs_pre_order(collector=[])
      collector << data

      if left.valid?
        left.dfs_pre_order(collector)
      end
      if right.valid?
        right.dfs_pre_order(collector)
      end
      
      collector
    end

    def to_s
      data
    end

    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

    def <=>(other)
      if value > other.value
        1
      elsif value < other.value
        -1
      elsif value == other.value
        0
      else
        nil
      end
    end

    def <(other)
      (self <=> other) < 0
    end

    def >(other)
      (self <=> other) > 0
    end

    def ==(other)
      self.class === other and hash == other.hash
    end
    alias_method  :eql?, :==

    def hash
      label.hash ^ value.hash # XOR
    end

  private

    def insert_left(node)
      self.left = node
      node.parent = self
      node
    end

    def insert_right(node)
      self.right = node
      node.parent = self
      node
    end

  end
end
