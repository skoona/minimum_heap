##
# File: <root>/lib/heaps/heap_base.rb
##
#
# A min-heap is a binary tree data structure in which the data of each node is less than or
# equal to the data of that node’s children and the tree is complete.
#
##
# best Reference: https://medium.freecodecamp.org/all-you-need-to-know-about-tree-data-structures-bceacb85490c
##
#  Heap nodes are numbered top to bottom, left to right; starting at 1
#  - Heap Property: Parent node must be less than either of the two allowed child nodes,
#    and left child less than right child.
#  - MinimumHeap are semi-ordered as a result of the Heap-Property
#  - Heaps are filled top-bottom, left-to-right
#
## Details
#
#  Row  Max.Cols  Tree.Cap
#    0      1         1                                      1
#                                                    /                 \
#    1      2         3                       2                               3
#                                           /   \                           /   \
#    2      4         7               4               5               6               7
#                                   /   \           /   \           /   \           /   \
#    3      8        15          8       9       10      11      12      13      14      15
#                               / \     / \     / \     / \     / \     / \     / \     / \
#    4     16        31       16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31
#
#    5     32        63
#
##   Operations
# Add:
#   - Place node at end
#   - Re-Establish Heap-Property using #move_up
#
# Pop:
#   - Swap last node with root
#   - destroy last node
#   - Re-Establish Heap-Property using #move_down
#
# Search:
#   - Start with root node
#   - test node, then left, then right
#   - return found node or nil (maybe empty node vs nil)
##

module Heaps

  class HeapBase

    attr_reader :root

    ##
    # Class Creates
    ##
    def self.heapify(user_datas_ary)
      new(user_datas_ary)
    end

    # Presumed input - one or more: [['description', value],...] | [{description: 'description', value: value},...]
    def initialize(args=[], max_min_type=false)
      @size = 0
      @root = Heaps::EmptyNode.new
      @last_node = @root
      @output_log = false

      # determine Heap Type, default is MinHeap
      if max_min_type
        @comparator = proc { |a, b| a < b }   # Maximum
      else
        @comparator = proc { |a, b| a > b }   # Minimum
      end

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
      node = insert_node_on_path(node, @size)
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

    def to_a(node=@root)
      node.dfs_pre_order
    end

    def display(node=@root)
      to_a(node).each do |item|
        dlog item.to_s
      end
    end

    private

    ##
    # Internal
    ##

    def valid_node(user_data)
      node = case user_data
               when Array
                 Heaps::Node.new( user_data.first, user_data.last)
               when Hash
                 Heaps::Node.new(user_data[:description], user_data[:value])
               when Heaps::Node
                 user_data
               else
                 nil
             end
      node.instance_variable_set(:@comparator, @comparator) unless node.nil?
      node
    end

    # Computes row/col to place this node
    # 0 row is root, 1,1 is root's left, 1,2 is root's right
    def insert_positions(pos=@size)
      pos = 1 if pos < 1
      row_number = (Math.log2(pos)).floor
      row_max_count = 2 ** row_number
      tree_capacity = 2 ** (row_number + 1 ) - 1
      target_column = row_max_count - (tree_capacity - pos)
      [row_number, target_column, row_max_count, tree_capacity]
    end

    def insert_node_on_path(node, insert_position=@size)
      nav_node = node_path_navigation(insert_position, true)
      raise ArgumentError, "#{__method__} Failed to locate an opening to insert node: #{node.to_s}" if nav_node.nil? or !nav_node.valid?

      node = nav_node.insert_node(node)
      raise ArgumentError, "#{__method__} Failed to insert node: #{node.to_s}" if nav_node == node

      @last_node = node

      maintain_heap_property(node)
    end

    # navigate directly to node number(size)
    def node_path_navigation(number_nodes, insert_mode=false)
      return root if number_nodes <= 1

      tgt_row, tgt_col, tgt_row_max, tgt_cap = insert_positions(number_nodes)

      row = 0
      nav_list = []
      while row < tgt_row do
        direction = ( tgt_col % 2 == 0 ) ? :right : :left
        nav_list.unshift( direction ) unless insert_mode
        insert_mode = false if insert_mode # stop one short of target on insert mode, by skipping first
        dlog("#{__method__} Row: #{tgt_row - row}, Direction: #{direction}, RowMax: #{tgt_row_max}, TargetColumn: #{tgt_col}")

        tgt_row_max = (tgt_row_max / 2)
        tgt_col = (tgt_col / 2.0).ceil
        row += 1
      end

      # move to node
      nav_node = root
      nav_list.each do |nav|
        nav_node = nav_node.send(nav)  # navigate
      end

      nav_node
    end

    # Heap Property: The value of parent is smaller than that of either child
    # - and both subtrees have the heap property.
    def maintain_heap_property(node)
      return node unless node&.parent&.valid?

      node = balance_subtree(node)

      eval_node = node.parent
      while eval_node.valid? do
        if eval_node.compare(node)
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
        node.swap_contents(@last_node)                  # Swap in value of last node to preserve last nodes value
        @last_node.clean                                # uncouple last node from tree
        @size -= 1
      end

      if @size > 1
        @last_node = node.move_down                     # restore heap properties
      else
        @last_node = node
      end

      node_value
    end

    def empty_object
      @empty_object ||= EmptyNode.new
    end

    def dlog(msg)
      return nil unless @output_log
      puts msg
      nil
    end

  end
end
