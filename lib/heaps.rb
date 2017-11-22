##
# File: <root>/lib/heaps.rb
##

# A min-heap is a binary tree data structure in which the data of each node is less than or
# equal to the data of that node’s children and the tree is complete.
#
##
# best Reference: https://medium.freecodecamp.org/all-you-need-to-know-about-tree-data-structures-bceacb85490c
##

require "heaps/version"
require "heaps/empty_node"
require "heaps/node"
require "heaps/base_node"

module Heaps

  class MinimumHeap

    attr_reader :root, :last_node

    ##
    # Class Creates
    ##
    def self.heapify(user_datas_ary)
      new(user_datas_ary)
    end

    # Presumed input - one or more: [['label', value],...] | [{label: 'label', value: value},...]
    def initialize(args=[])
      @size = 0
      @root = Heaps::EmptyNode.new
      @last_node = @root
      @debug = false

      unless args.empty?
        case args.first
          when String
            push( args )
          else
            args.each {|udata| push( udata ) }
        end
      end
      true
    end

    ##
    # Basic
    ##
    def push(user_data)
      node = valid_node( user_data)
      return nil if node.nil?

      unless root.nil? or root.valid?
        @root = node
        @size = 1
        dlog "#{__method__} Inserted at R/C/mR/cT => #{insert_positions}, Root.Node => #{node.to_s}, Node.Parent => #{node.parent.to_s}"
        @last_node = @root
        return nil
      end

      @size += 1
      node = insertion_path(node)
      dlog "#{__method__} Inserted at R/C/mR/cT => #{insert_positions}, Node => #{node.to_s}, Node.Parent => #{node.parent.to_s}"
      nil
    end
    alias_method :<<, :push

    # Remove root and adjust heap
    def pop
      dlog "Removing Node: #{@root.to_s}"
      remove(@root)
    end

    def peek
      @root.data
    end

    # Remove root and immediately replace with user_data, i.e. new_node
    def replace!(user_data)
      node = valid_node(user_data)
      return nil if node.nil?

      dlog "Replacing Node: #{@root.to_s}, with #{node.to_s}"
      remove(@root, node)
    end

    # Returns deleted node's data or nil
    def delete!(user_data)
      node = include?(user_data, true)
      return nil if node.nil?
      dlog "Deleteing Node: #{node.to_s}"
      remove(node)
    end

    # Drops all tree references in every tree node,
    # - expecting GC to cleanup disconnected nodes
    def clear!
      root.clean(true)
      @root = empty_object
      @last_node = @root
      @size = 0
      nil
    end

    ##
    # Creation
    ##

    # new_heap = this + other, retaining source heaps
    def merge(other_heap)
      return nil unless other_heap.is_a?(self.class)
      combined = (self.to_a + other_heap.to_a).flatten.uniq
      self.class.heapify(combined)
    end

    # this_heap = this + other, retaining other intact
    def merge!(other_heap)
      return nil unless other_heap.is_a?(self.class)
      other_heap.to_a.each do |user_data|
        push(user_data)
      end
      self
    end

    # new_heap = this + other, destroying this and other
    def union!(other_heap)
      return nil unless other_heap.is_a?(self.class)
      combined = (self.to_a + other_heap.to_a).flatten.uniq
      other_heap.clear!
      clear!
      self.class.heapify(combined)
    end

    ##
    # Inspection
    ##
    def include?(user_data, node_only=false)
      node = valid_node(user_data)
      return nil if node.nil?
      node = root.include?(node)
      node&.valid? ? (node_only ? node : node.to_s) : nil
    end

    def size
      @size
    end
    alias_method :length, :size

    def empty?
      @size == 0
    end

    def inspect
      @root.inspect
    end
    alias_method :to_s, :inspect

    def to_a
      @root.dfs_pre_order
    end

    def display(node=@root)
      node.dfs_pre_order.each do |item|
        dlog item
      end
    end

    private

    ##
    # Internal
    ##

    def valid_node(user_data)
      case user_data
        when Array
          Heaps::Node.new( user_data.first, user_data.last)
        when Hash
          Heaps::Node.new(user_data[:label], user_data[:value])
        when Heaps::Node
          user_data
        else
          nil
      end
    end

    # Computes row/col to place this node
    # 0 row is root, 1,1 is root's left, 1,2 is root's right
    def insert_positions(pos=@size)
      pos = 1 if pos < 1
      row_number = (Math.log2(pos)).floor
      row_max_count = 2 ** row_number
      tree_capacity = 2 ** (row_number + 1 ) - 1
      target_location = row_max_count - (tree_capacity - pos)
      [row_number, target_location, row_max_count, tree_capacity]
    end

    # navigate directly to node number(size)
    # if node is not a Node, will return the node at number_number requested
    def insertion_path(node, number_number=@size)
      tgt_row, tgt_col, tgt_row_max, tgt_cap = insert_positions(number_number)

      return node if number_number == 1

      nav_list = []
      nav_node = root
      row = 0

      while row < tgt_row do
        direction = ( tgt_col % 2 == 0 ) ? :right : :left
        nav_list << direction
        dlog("#{__method__} Row: #{tgt_row - row}, Direction: #{direction}, RowMax: #{tgt_row_max}, TargetColumn: #{tgt_col}")

        tgt_row_max = (tgt_row_max / 2)
        tgt_col = (tgt_col / 2.0).ceil
        row += 1
      end

      nav_list.shift if node.is_a?(Node)  # assume insert mode and stop one short of target

      # Currently Backwards, so reverse before use
      nav_list.reverse.each do |msg|     # navigate
        nav_node = nav_node.send(msg)
      end

      # do the insertion
      if node.is_a?(Node)
        node = nav_node.insert_node(node)
        raise ArgumentError, "#{__method__} Failed to insert node: #{node.to_s}" if nav_node == node
        @last_node = node
        node = maintain_heap_property(node)
      end

      node
    end

    # Heap Property: The value of parent is smaller than that of either child
    # - and both subtrees have the heap property.
    def maintain_heap_property(node)
      return node unless node&.parent&.valid?

      node = balance_subtree(node)

      eval_node = node.parent
      while eval_node.valid? do
        if (eval_node <=> node) > 0
          node = balance_subtree( eval_node.swap_contents(node) )
          eval_node = node.parent
        else
          eval_node = balance_subtree ( eval_node.parent )
        end
      end

      node
    end

    # The left child must be smaller than the right child,
    # - and both must be greater than the parent
    def balance_subtree(node)
      return node unless node.valid? and
                    node.parent.valid? and
                      node.parent.left.valid? and
                        node.parent.right.valid?  # nothing to balance

      if node.parent.left != node && node.parent.left > node
        node = node.parent.left.swap_contents(node)
      end

      node
    end

    # Remove node and replace it with last node inserted
    # - or swap it with replacement node if supplied
    def remove(node, replacement_node=nil)
      return node unless node&.valid?
      node_value = node.data                          # stash nodes data for method return

      if replacement_node
        node.swap_contents(replacement_node)           # Swap in value of last node to preserve last nodes value
        replacement_node.clean                         # remove tree references from last node, allowing GC

      else
        node.swap_contents(last_node)                  # Swap in value of last node to preserve last nodes value
        last_node.clean                                # uncouple last node from tree
        @size -= 1
      end

      if size > 1
        @last_node = node.move_down                    # restore heap properties
      else
        @last_node = node
      end

      node_value
    end

    def empty_object
      @empty_object ||= EmptyNode.new
    end

    def dlog(msg)
      return nil unless @debug
      puts msg
      nil
    end

  end
end

