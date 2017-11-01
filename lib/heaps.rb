##
# File: <root>/lib/heaps.rb
##

# A min-heap is a binary tree data structure in which the data of each node is less than or
# equal to the data of that node’s children and the tree is complete.

# - All child nodes are larger than their parent
# - The smallest element of the min-heap is at the root
# - They can refer to another node to the left with a smaller value
# - They can refer to another node to the right with a larger value

# Ref: https://en.wikipedia.org/wiki/Heap_(data_structure)
# Ref: https://en.wikibooks.org/wiki/Data_Structures/Min_and_Max_Heaps

# A heap is an efficient semi-ordered data structure for storing a collection of orderable data. A min-heap
# supports two operations:
#
#    INSERT(heap, element)
#    element REMOVE_MIN(heap)
#
# ( we discuss min-heaps, but there's no real difference between min and max heaps,
#   except how the comparison is interpreted. )
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
# A heap is implemented using an array that is indexed from 1 to N, where N is the number of elements in the heap.
#
#    At any time, the heap must satisfy the heap property
#
#        array[n] <= array[2*n]   // parent element <= left child
#    and
#        array[n] <= array[2*n+1] // parent element <= right child

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
#     removing the root node of a max heap [or min heap], respectively
#   replace:
#     pop root and push a new key. More efficient than pop followed by push, since only need
#     to balance once, not twice, and appropriate for fixed-size heaps.[5]
#
# Creation
# ---------
#   create-heap:
#     create an empty heap
#   heapify:
#     create a heap out of given array of elements
#   merge (union):
#     joining two heaps to form a valid new heap containing all the elements of both, preserving the original heaps.
#   meld:
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



require "heaps/version"
require "heaps/empty_node"
require "heaps/node"
require "heaps/min_heap"
require "binary_tree/empty_node"
require "binary_tree/node"


module Heaps

  class MinimumHeap
    attr_reader :root
    attr_reader :count

    def initialize(initial_root)
      @root = initial_root
      @count = 1
      @position = 1
    end

    # root must be lowest value
    # Parents must be lower value than children
    # - test for lower than root
    # - search row-wise for available slot with parent less than new-node - insert
    # - re-shuffle to make tree Complete
    def insert(node)
      return if node.nil?
      puts "Inserting #{node.title}: #{node.value}"
      @count += 1

      puts "\tBefore: #{root.inspect}"

      tree_node = find_insert_positon(node)
      if node.value < root.value
        root_swap(node)
      else
        tree_node.parent.insert(node)
      end

      puts "\t After: #{root.inspect}"

      display_tree(root)
      puts "=========="
    end

    def find_insert_positon(node)
      row_number = (Math.log2(@count)).floor
      row_max_count = 2 ** row_number
      tree_capacity = 2 ** (row_number + 1 ) - 1
      target_location = row_max_count - (tree_capacity - @count)

      tree_index = 1
      tree_node = root
      while tree_node.left.valid?                    # tree < node, do until greater
        tree_node = case tree_node.parent <=> node
                      when 1
                        tree_node.left.valid? ? tree_node.left  : tree_node.right.valid? ? tree_node.right  : break
                      when -1
                        tree_node.right.valid? ? tree_node.right  : tree_node.left.valid? ? tree_node.left  : break
                      else break
                    end
        tree_index += 1                       # tree_index == row_number
      end

      # either leaf or tree > node
      puts "TREE-NODE: #{tree_node.inspect}  ==> RowCalc: #{row_number}, Target: #{target_location}, Location: #{tree_index}"

      tree_node
    end

    def root_swap(node)
      puts "#{__method__}..."
      temp = root
      if temp.right.valid?     # present
        node.right = temp.right
        node.left = temp
        node.left.parent = node
        node.right.parent = node
        temp.right = EmptyNode.new()
      else
        node.left = temp
        node.left.parent = node
      end
      @root = node
      node
    end

    def swap_up(node)
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

    def display_tree(node=@root)
      node.to_a.each do |item|
        puts item
      end
    end

  end


end
