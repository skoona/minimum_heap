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
      node = insert_node( node)
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

    def insertion_path(node, nodes=@size)
      tgt_row, tgt_col, tgt_row_max, tgt_cap = insert_positions(nodes)

      return node if nodes == 1
      
      nav_node = root
      row = 1

      direction = ( tgt_col % 2 == 0 ) ? :right : :left
      tree_base = direction
      dlog("#{__method__} Row: #{tgt_row}, Direction: #{direction}, RowMax: #{tgt_row_max}, TargetColumn: #{tgt_col}")

      while row < tgt_row do
        tgt_row_max = (tgt_row_max / 2)
        tgt_col = (tgt_col / 2.0).ceil

        direction = ( tgt_col % 2 == 0 ) ? :right : :left
        # nav_node = nav_node.send( direction )
        dlog("#{__method__} Row: #{tgt_row - row}, Direction: #{direction}, RowMax: #{tgt_row_max}, TargetColumn: #{tgt_col}")

        row += 1
      end
    end

    # returns this_node on success
    def insert_node(this_node)
      row = 1
      nav_node = root
      prow, pcol, pmax, pcap = insert_positions

      if @last_node.valid? and @last_node.parent.valid? and pcol != 1
        nav_node = @last_node.parent

      else # used to find column 1 on row changes
        dlog("#{__method__} Column Calcs: #{( pcol > (pmax / 2.0).ceil )}, Row: #{prow}, pCol: #{pcol}, pMax: #{pmax}, Ceil: #{(pmax / 2.0).ceil}")

        while prow > row  do                             # position to target row
          nav_node = nav_node.left
          row += 1
        end
      end

      @last_node = row_wise_insert(nav_node, this_node)

      maintain_heap_property(this_node)
    end
    
    # Row Wise Insertions
    def row_wise_insert(snode, new_node)
      dlog "#{__method__} (Top) Node => #{snode.to_s}, New.Node => #{new_node.to_s}"

      node = snode.insert_node( new_node )

      unless node == new_node
        dlog "#{__method__} (Ix) Node => #{node.to_s},  node.parent.valid? => #{node.parent.valid?}"
        dlog "#{__method__} (Ix) Node => #{node.to_s},  node.parent.right.valid? => #{node.parent.right.valid?}"
        dlog "#{__method__} (Ix) Node => #{node.to_s},  node.parent.right == node => #{node.parent.right == node}"

        count = 0
        while node.parent.valid? &&
                node.parent.right.valid? &&
                  node.parent.right == node do     # walk up to find path to right column
          node = node.parent
          count += 1
          dlog "#{__method__} (I0) Node => #{node.to_s}, Node.Parent.Right => #{node.parent.right.to_s}"
        end

        dlog(root.inspect)

        node = node.parent.right                   # Turn the corner

        dlog "#{__method__} (I1) Count: #{count}, Node => #{node.to_s}, New.Node => #{new_node.to_s}"

        while count > 0 && node.left.valid? do     # walk down to row
          node = node.left
          count -= 1
        end

        dlog "#{__method__} (I2) Node => #{node.to_s}, New.Node => #{new_node.to_s}"
        node = row_wise_insert( node , new_node )
      end

      dlog "#{__method__} (Exit) Last.Node => #{node.to_s}, New.Node => #{new_node.to_s}, Tree => #{root.inspect}"
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

