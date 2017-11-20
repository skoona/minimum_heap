##
# File: <root>/lib/heaps.rb
##

# A min-heap is a binary tree data structure in which the data of each node is less than or
# equal to the data of that node’s children and the tree is complete.

# - All child nodes are larger than their parent
# - The smallest element of the min-heap is at the root
# - The left child of a parent is less than the right child of same parent

# Ref: https://en.wikipedia.org/wiki/Heap_(data_structure)
# Ref: https://en.wikibooks.org/wiki/Data_Structures/Min_and_Max_Heaps

# A heap is an efficient semi-ordered data structure for storing a collection of orderable data. A min-heap
# supports two operations:
#
#    INSERT(heap, element)
#    element REMOVE_MIN(heap)
#
# ( There's no real difference between min and max heaps, except how the comparison is interpreted. )
#
# Although different types of heaps exist. The term binary heap and heap are interchangeable in
# most cases. A heap can be thought of as a tree with parent and child. The main difference
# between a heap and a binary tree is the heap property.  In order for a data structure to be
# considered a heap, it must satisfy the following condition (heap property):
#
#    If A and B are elements in the heap and B is a child of A, then key(A) ≤ key(B).
#    (This property applies for a min-heap. A max heap would have the comparison reversed).

#     What this tells us is that the minimum key will always remain at the top and greater
#     values will be below it. Due to this fact, heaps are used to implement priority queues
#     which allows quick access to the item with the most priority. Here's an example of a min-heap:
#
#   [Minimal-Heap](https://upload.wikimedia.org/wikipedia/commons/5/5c/Binary-heap.png)
#
# Operations[edit]
# The common operations involving heaps are:
#
# Basic
# ---------
#   find-max or find-min:
#     find a maximum item of a max-heap, or a minimum item of a min-heap, respectively (a.k.a. peek)
#   insert:
#     adding a new key to the heap (a.k.a., push[3])
#   extract-max [or extract-min]:
#     returns the node of maximum value from a max heap [or minimum value from a min heap] after
#     removing it from the heap (a.k.a., pop[4])
#   delete-max [or delete-min]:
#     removing any node of a max heap [or min heap], respectively
#   replace:
#     pop root and push a new key. More efficient than pop followed by push, since only need
#     to balance once, not twice, and appropriate for fixed-size heaps.
#
# Creation
# ---------
#   create-heap:
#     create an empty heap
#   heapify:
#     create a heap out of given array of elements
#   merge (union):
#     joining two heaps to form a valid new heap containing all the elements of both, preserving the original heaps.
#   merge!
#     joining two heaps to form a valid new heap containing all the elements of both, destroying the original heaps.
#
# Inspection
# ---------
#   size:
#     return the number of items in the heap.
#   is-empty:
#     return true if the heap is empty, false otherwise.
#
# Internal
# ---------
#   increase-key or decrease-key:
#     updating a key within a max- or min-heap, respectively
#   delete:
#     delete an arbitrary node (followed by moving last node and sifting to maintain heap)
#   sift-up:
#     move a node up in the tree, as long as needed; used to restore heap condition after insertion. Called "sift" because node moves up the tree until it reaches the correct level, as in a sieve.
#   sift-down:
#     move a node down in the tree, similar to sift-up; used to restore heap condition after deletion or replacement.
##



require "heaps/version"
require "heaps/empty_node"
require "heaps/node"


module Heaps

  class MinimumHeap

    attr_reader :root, :last_node

    ##
    # Class Creates
    ##
    def self.heapify(*user_datas_ary)
      new(*user_datas_ary)
    end

    # Presumed input - one or more: [['label', value],...] | [{label: 'label', value: value},...]
    def initialize(*args)
      @size = 0
      @root = Heaps::EmptyNode.new
      @last_node = @root
      @debug = false

      unless args.empty?
        case args.first.first
          when Array
            args.first.each {|udata| push( udata ) }
          when Hash
            args.first.each {|udata| push( udata ) }
          when String
            args.each {|udata| push( udata ) }
          else
            push( args )
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

      if !root.valid? and @size == 0
        @root = node
        @size += 1
        dlog "#{__method__} Inserted at R/C/mR/cT => #{insert_positions}, Root.Node => #{node.to_s}, Node.Parent => #{node.parent.to_s}"
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

    # Remove root and immediately replace with user_data, i.e. new_node
    def replace!(user_data)
      node = valid_node(user_data)
      return nil if node.nil?

      dlog "Replacing Node: #{@root.to_s}, with #{node.to_s}"
      remove(@root, node)
    end

    def peek
      @root.data
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

    # new_heap = this + other, destroying both
    def union(other_heap)
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
      @root.to_a
    end

    def display(node=@root)
      node.to_a.each do |item|
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
          Heaps::Node.new( *user_data)
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
    def insert_positions
      row_number = (Math.log2(size)).floor
      row_max_count = 2 ** row_number
      tree_capacity = 2 ** (row_number + 1 ) - 1
      target_location = row_max_count - (tree_capacity - size)
      [row_number, target_location, row_max_count, tree_capacity]
    end

    # returns this_node on success
    def insert_node(this_node)
      row = 1
      nav_node = root

      prow, pcol, pmax, pcap = insert_positions

      while prow > row  do                             # position to target row
        nav_node = nav_node.left
        row += 1
      end

      @last_node = row_wise_insert(nav_node, this_node)

      maintain_heap_property(this_node)
    end
    
    # Row Wise Insertions
    def row_wise_insert(snode, new_node)
      node = snode.insert_node( new_node )

      if node != new_node
        count = 0
        while node.parent.right == node do     # walk up to find path to right column
          node = node.parent
          count += 1
        end
        node = node.parent.right               # move into right column
        while count > 0 && node.left.valid? do # walk down to row
          node = node.left
          count -= 1
        end

        node = row_wise_insert( node , new_node )
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

      if node.parent.left == node
        if (node.parent.right <=> node) < 0
          node = node.parent.right.swap_contents(node)
        end
      else
        if (node.parent.left <=> node) > 0
          node = node.parent.left.swap_contents(node)
        end
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

    # Row Wise Collector
    # - use to force #to_a to return ordered sequence
    def row_wise_collector(node, new_node)

      if node != new_node
        count = 0
        while node.parent.right == node do     # walk up to find path to right column
          node = node.parent
          count += 1
        end

        node = node.parent.right               # move into right column

        while count > 0 && node.left.valid? do # walk down to row
          node = node.left
          count -= 1
        end

        node = row_wise_collector( node , new_node )
      end

      node
    end

    def empty_object
      @empty_object ||= EmptyNode.new
    end

    def dlog(msg)
      puts msg if @debug
    end

  end
end
