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
##



require "heaps/version"
require "heaps/empty_node"
require "heaps/node"


module Heaps

  class MinimumHeap

    attr_reader :root

    # Presumed input: ['label', value] | [['label', value],...] | [{label: 'label', value: value},...]
    def initialize(*args)
      @size = 1
      @root = Heaps::EmptyNode.new
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
      if !root.valid? and @size == 1
        @root = node
        puts "#{__method__} Inserted at R/C/mR/cT => #{insert_positions}, Root.Node => #{node.to_s}, Node.Parent => #{node.parent.to_s}"
        return nil
      else
        @size += 1
      end
      node = insert_node( node)
      puts "#{__method__} Inserted at R/C/mR/cT => #{insert_positions}, Node => #{node.to_s}, Node.Parent => #{node.parent.to_s}"
      nil
    end
    alias_method :<<, :push

    def pop
      remove(@root)
    end

    def replace(user_data)
      node = valid_node(user_data)
    end

    def peek
      @root.data
    end

    def delete(user_data)
      node = valid_node(user_data)
    end

    # severs the tree after root node, expecting GC to cleanup
    def clear!
      root.left.parent ? (root.left.parent = nil) : nil
      root.right.parent ? (root.right.parent = nil) : nil
      root.left = nil
      root.right = nil
      root.parent = nil
      @root = nil
      @size = 0
      nil
    end

    ##
    # Creation
    ##
    def self.heapify(*user_datas_ary)
      new(*user_datas_ary)
    end

    # new_heap = this + other
    def merge(other_heap)
      return nil unless other_heap.is_a?(self.class)
      combined = (self.to_a + other_heap.to_a).flatten.uniq
      other_heap.clear!
      self.clear!
      self.class.heapify(combined)
    end

    # this_heap += other
    def merge!(other_heap)
      return nil unless other_heap.is_a?(self.class)
      other_heap.to_a.flatten.each do |user_data|
        push( valid_node(user_data) )
      end
      self
    end

    ##
    # Inspection
    ##
    def include?(user_data)
      node = valid_node(user_data)
    end

    def size
      @size
    end
    alias_method :length, :size

    def empty?
      @size == 0
    end

    def inspect
      @root.send __method__
    end
    alias_method :to_s, :inspect

    def to_a
      @root.send __method__
    end

    def display(node=@root)
      node.to_a.each do |item|
        puts item
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

    # returns this_node on sucess
    def insert_node(this_node)
      row = 1
      nav_node = nil

      prow, pcol, pmax, pcap = insert_positions

      while prow > row  do                             # position to target row
        nav_node = root if nav_node.nil?
        nav_node = nav_node.left
        row += 1
      end
      nav_node = root if nav_node.nil?

      row_wise_insert(nav_node, this_node)

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

        row_wise_insert( node , new_node )
      end

      node
    end

    def maintain_heap_property(node)
      return node unless node.valid? and node.parent.valid?

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

    def remove(node)
      self.size -= 1
      node.data
    end

    def empty_object
      @empty_object ||= EmptyNode.new
    end

  end
end


# push Insert Root, R/C => [0, 1, 1, 1]
# push Insert at R/C => [1, 1, 2, 3]
# Row: 1, TargetRow: 1
# ** Row: 1, TargetRow: 1 StartNode: {:label=>"The Matrix", :value=>70}
# row_wise_insert Inserted: {:label=>"Pacific Rim", :value=>72}
# push Insert at R/C => [1, 2, 2, 3]
# Row: 1, TargetRow: 1
# ** Row: 1, TargetRow: 1 StartNode: {:label=>"The Matrix", :value=>70}
# row_wise_insert Inserted: {:label=>"Braveheart", :value=>78}
# push Insert at R/C => [2, 1, 4, 7]
# Row: 1, TargetRow: 2
#   Row: 1, TargetRow: 2
# ** Row: 2, TargetRow: 2 StartNode: {:label=>"Pacific Rim", :value=>72}
# row_wise_insert Inserted: {:label=>"Star Wars: Return of the Jedi", :value=>80}
# push Insert at R/C => [2, 2, 4, 7]
# Row: 1, TargetRow: 2
#   Row: 1, TargetRow: 2
# ** Row: 2, TargetRow: 2 StartNode: {:label=>"Pacific Rim", :value=>72}
# row_wise_insert Inserted: {:label=>"Donnie Darko", :value=>85}
# push Insert at R/C => [2, 3, 4, 7]
# Row: 1, TargetRow: 2
#   Row: 1, TargetRow: 2
# ** Row: 2, TargetRow: 2 StartNode: {:label=>"Pacific Rim", :value=>72}
#   row_wise_insert Bridging: {:label=>"Braveheart", :value=>78}
# ** row_wise_insert Bridging: {:label=>"Braveheart", :value=>78}
# row_wise_insert Inserted: {:label=>"Inception", :value=>86}
# push Insert at R/C => [2, 4, 4, 7]
# Row: 1, TargetRow: 2
#   Row: 1, TargetRow: 2
# ** Row: 2, TargetRow: 2 StartNode: {:label=>"Pacific Rim", :value=>72}
#   row_wise_insert Bridging: {:label=>"Braveheart", :value=>78}
# ** row_wise_insert Bridging: {:label=>"Braveheart", :value=>78}
# row_wise_insert Inserted: {:label=>"District 9", :value=>90}
# push Insert at R/C => [3, 1, 8, 15]
# Row: 1, TargetRow: 3
#   Row: 1, TargetRow: 3
#   Row: 2, TargetRow: 3
# ** Row: 3, TargetRow: 3 StartNode: {:label=>"Star Wars: Return of the Jedi", :value=>80}
# row_wise_insert Inserted: {:label=>"The Shawshank Redemption", :value=>91}
# push Insert at R/C => [3, 2, 8, 15]
# Row: 1, TargetRow: 3
#   Row: 1, TargetRow: 3
#   Row: 2, TargetRow: 3
# ** Row: 3, TargetRow: 3 StartNode: {:label=>"Star Wars: Return of the Jedi", :value=>80}
# row_wise_insert Inserted: {:label=>"The Martian", :value=>92}
# push Insert at R/C => [3, 3, 8, 15]
# Row: 1, TargetRow: 3
#   Row: 1, TargetRow: 3
#   Row: 2, TargetRow: 3
# ** Row: 3, TargetRow: 3 StartNode: {:label=>"Star Wars: Return of the Jedi", :value=>80}
#   row_wise_insert Bridging: {:label=>"Donnie Darko", :value=>85}
# ** row_wise_insert Bridging: {:label=>"Donnie Darko", :value=>85}
# row_wise_insert Inserted: {:label=>"Star Wars: A New Hope", :value=>93}
# push Insert at R/C => [3, 4, 8, 15]
# Row: 1, TargetRow: 3
#   Row: 1, TargetRow: 3
#   Row: 2, TargetRow: 3
# ** Row: 3, TargetRow: 3 StartNode: {:label=>"Star Wars: Return of the Jedi", :value=>80}
#   row_wise_insert Bridging: {:label=>"Donnie Darko", :value=>85}
# ** row_wise_insert Bridging: {:label=>"Donnie Darko", :value=>85}
# row_wise_insert Inserted: {:label=>"Star Wars: The Empire Strikes Back", :value=>94}
#
# {70:{72:{80:{91:{}|{}}|{92:{}|{}}}|{85:{93:{}|{}}|{94:{}|{}}}}|{78:{86:{}|{}}|{90:{}|{}}}}


# push Inserted at R/C/mR/cT => [0, 1, 1, 1], Root.Node => {:label=>"Star Wars: Return of the Jedi", :value=>80}, Node.Parent => {:title=>"Heaps::EmptyNode", :value=>-1}
# {80:{}|{}}

# maintain_heap_property Accepting: {:label=>"Donnie Darko", :value=>85}
# push Inserted at R/C/mR/cT => [1, 1, 2, 3], Node => {:label=>"Donnie Darko", :value=>85}, Node.Parent => {:label=>"Star Wars: Return of the Jedi", :value=>80}
# {80:{85:{}|{}}|{}}

# maintain_heap_property Accepting: {:label=>"Inception", :value=>86}
# balance_subtree Accepting: {:label=>"Inception", :value=>86}
# balance_subtree Passing thru: {:label=>"Inception", :value=>86}
# push Inserted at R/C/mR/cT => [1, 2, 2, 3], Node => {:label=>"Inception", :value=>86}, Node.Parent => {:label=>"Star Wars: Return of the Jedi", :value=>80}
# {80:{85:{}|{}}|{86:{}|{}}}

# maintain_heap_property Accepting: {:label=>"Mad Max 2: The Road Warrior", :value=>98}
# push Inserted at R/C/mR/cT => [2, 1, 4, 7], Node => {:label=>"Mad Max 2: The Road Warrior", :value=>98}, Node.Parent => {:label=>"Donnie Darko", :value=>85}
# {80:{85:{98:{}|{}}|{}}|{86:{}|{}}}

# maintain_heap_property Accepting: {:label=>"The Matrix", :value=>70}
# swap_contents Replacing: {:label=>"Donnie Darko", :value=>85} with {:label=>"The Matrix", :value=>70}
# swap_contents Replacing: {:label=>"Star Wars: Return of the Jedi", :value=>80} with {:label=>"The Matrix", :value=>70}
# push Inserted at R/C/mR/cT => [2, 2, 4, 7], Node => {:label=>"The Matrix", :value=>70}, Node.Parent => {:title=>"Heaps::EmptyNode", :value=>-1}
# {70:{80:{98:{}|{}}|{85:{}|{}}}|{86:{}|{}}}

# maintain_heap_property Accepting: {:label=>"Pacific Rim", :value=>72}
# swap_contents Replacing: {:label=>"Inception", :value=>86} with {:label=>"Pacific Rim", :value=>72}
# balance_subtree Accepting: {:label=>"Pacific Rim", :value=>72}
# balance_subtree Swapping Left: 80 > 72
# swap_contents Replacing: {:label=>"Star Wars: Return of the Jedi", :value=>80} with {:label=>"Pacific Rim", :value=>72}
# balance_subtree Passing thru: {:label=>"Pacific Rim", :value=>72}
# push Inserted at R/C/mR/cT => [2, 3, 4, 7], Node => {:label=>"Pacific Rim", :value=>72}, Node.Parent => {:label=>"The Matrix", :value=>70}
# {70:{72:{98:{}|{}}|{85:{}|{}}}|{80:{86:{}|{}}|{}}}

# {:label=>"Mad Max 2: The Road Warrior", :value=>98}
# {:label=>"Pacific Rim", :value=>72}
# {:label=>"Donnie Darko", :value=>85}
# {:label=>"The Matrix", :value=>70}
# {:label=>"Inception", :value=>86}
# {:label=>"Star Wars: Return of the Jedi", :value=>80}
