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
      true
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
      (label == other_node.label && value == other_node.value ? self : nil) ||
          (left.valid? ? left.include?(other_node) : nil) ||
          (right.valid? ? right.include?(other_node) : nil)
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

      maintain_child_property(self)

      if left.valid? and (self <=> left) > 0                # Must be more than parent:
        swap_contents(left)
        maintain_child_property(self)
      end

      if right.valid? and (self <=> right) > 0              # Must be more than parent:
        swap_contents(right)
        maintain_child_property(self)
      end

      nleft  = left.move_down  if left.valid?
      nright = right.move_down if right.valid?

      nright || nleft || self
    end

    def swap_contents(node)
      old = data
      self.data = node.data
      node.data = old
      self
    end

    def clean(children=false)
      if children
        left.valid?  ? left.clean(children) : nil
        right.valid? ? right.clean(children) : nil
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

    def to_s
      data
    end

    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

    def to_a
      left.to_a + [data] + right.to_a
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
      hash < other.hash
    end

    def >(other)
      hash > other.hash
    end

    def ==(other)
      self.class === other and hash == other.hash
    end
    alias_method  :eql?, :==

    def hash
      label.hash ^ value.hash # XOR
    end

  private

    # The left child must be smaller than the right child,
    # - and both must be greater than the parent
    def maintain_child_property(node)
      return node unless node&.valid? and
                         node&.left&.valid? and
                         node&.right&.valid?      # nothing to balance

      if (node.left <=> node.right) > 0
        node = node.left.swap_contents(node.right)
      end

      node
    end

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
