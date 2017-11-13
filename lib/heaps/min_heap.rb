##
# File: <root>/lib/binary_tree/node.rb
##
# tree.root
# => {72:{87:{}|{}}|{78:{}|{80:{}|{}}}}
# tree.root.to_a
# => => ["The Matrix: 87", "Pacific Rim: 72", "Braveheart: 78", "Star Wars: Return of the Jedi: 80"]
#
#               Actual                   Desired
#                  72                       72
#                /   \                    /   \
#              87    78                 78    80
#                   /  \               /  \
#                      80             87
##
# A heap is an efficient semi-ordered data structure for storing a collection of orderable data. A min-heap
# supports two operations:
#
#    INSERT(heap, element)
#    element REMOVE_MIN(heap)
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


module Heaps

  class MinHeap

    # Presumed input: [{title: 'title', value: 1}, ...]
    def initialize(*args)
      @size = 0
      @root = Heaps::EmptyNode.new
      args.each do|value|
        push( valid_node(value) )
      end
    end

    ##
    # Basic
    ##
    def push(value)
      # row_number = (Math.log2(@count)).floor
      # row_max_count = 2 ** row_number
      # tree_capacity = 2 ** (row_number + 1 ) - 1
      # target_location = row_max_count - (tree_capacity - @count)

      node = valid_node(value)
      if @size == 0
        @root = node
        @size += 1
        return nil
      end
      @size += 1
      newest_node = @root.insert_node(node)
      nil
    end
    alias_method :<<, :push
    alias_method :insert,:push

    def pop
      remove(@root)
    end

    def peek
      @root
    end

    def delete(value)
      node = valid_node(value)
    end

    ##
    # Creation
    ##
    def self.heapify(*values_ary)
      new(values_ary)
    end

    # new_heap = this + other
    def merge(other_heap)
      return nil unless other_heap.is_a?(self.class)
      combined = (self.to_a + other_heap.to_a).flatten.uniq
      self.class.heapify(combined)
    end

    # this_heap += other
    def merge!(other_heap)
      return nil unless other_heap.is_a?(self.class)
      other_heap.to_a.each do|value|
        push( valid_node(value) )
      end
      self
    end

    ##
    # Inspection
    ##
    def include?(value)
      node = valid_node(value)
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
        puts item
      end
    end

  private

    ##
    # Internal
    ##

    # Consider
    # parent.value, left.value, right.value, and this.value
    # returns this_node
    def insert_node(this_node, starting_node=nil)
      #  swap:  this < parent
      #  down:  this >= parent
      #  LEFT:  this > left && this < right
      # RIGHT:  this > left && this > right
    end

    def valid_node(input_value)
      input_value.is_a?(Hash) ?
          Heaps::Node.new(input_value[:title], input_value[:value]) :
          input_value
    end

    def remove(node)
      size -= 1
    end

    def move_up(node)
    end

    def move_down(node)
    end

  end
end
