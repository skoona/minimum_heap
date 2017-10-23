##
# File: <root>/lib/minimum_heap.rb


# A min-heap is a binary tree data structure in which the data of each node is less than or
# equal to the data of that node’s children and the tree is complete.

# - All child nodes are larger than their parent
# - The smallest element of the min-heap is at the root
# - They can refer to another node to the left with a smaller value
# - They can refer to another node to the right with a larger value

# - The children of an element at a given index i will always be in 2i and 2i + 1.
# - The parent of a node will be at the index i/2.

require "heaps/version"
require "heaps/empty_node"
require "heaps/node"

module Heaps

  class InvalidNode < StandardError; end

  class MinimumHeap
    attr_reader :root
    attr_reader :count

    def initialize(initial_root)
      @root = initial_root
      @count = 1
      @position = 1
    end

    def insert(node)
      return if node.nil?
      puts "Inserting #{node.title}: #{node.rating}"

      parent_node = find_parent(root, node)
      puts parent_node.inspect
      if parent_node == root or parent_node.is_a?(EmptyNode)
        root_swap(node)
      else
        parent_node.insert(node)
      end

      # was it assigned?  parent set?

      display_tree(root)
      puts "=========="
    end

    def insert_left(parent, node)
    end
    def insert_right(parent,node)
    end

    # existing node with rating less than node's
    def find_parent(tree_node, node)
      case tree_node <=> node
        when -1
          puts "Less than #{tree_node.title}"
          find_parent(tree_node.right, node) if tree_node.right.valid?
        when 1
          puts "More than #{tree_node.title}"
          find_parent(tree_node.left, node) if tree_node.left.valid?
        else
          puts "Invalid Comparison #{tree_node.title}"
        # tree_node = EmptyNode.new
      end
      puts "Tree Node's Rating is #{tree_node.rating}"
      tree_node
    end

    def root_swap(node)
      temp = root
      node.left = temp
      @root = node
    end

    def insertp(rnode = nil, node)
      start_node = rnode.nil? ? root : rnode
      puts "Inserting #{node.title}: #{node.rating}"
      @count += 1
      row_number = (Math.log2(@count)).floor
      row_max_count = 2 ** row_number
      tree_capacity = 2 ** (row_number + 1 ) - 1
      target_location = row_max_count - (tree_capacity - @count)
      return nil if node.nil?

      current_location = 0
      while start_node.left != nil do
        start_node = start_node.left
        current_location += 1
        break if current_location > row_max_count
      end

      if target_location <= (row_max_count / 2)
        # go left
        if start_node.left == nil
          start_node.left = node
          node.parent = start_node
          swap_up(node)
          return
        else
          insert(start_node.left, node)
        end

      else
        # go right
        if start_node.right == nil
          start_node.right = node
          node.parent = root
          swap_up(node)
          return
        else
          insert(start_node.right, node)
        end
      end

      display_tree(root)
      puts "=========="
    end

    def swap_up(node)
      parent_node = node.parent
      # unless pacific rim is nil || pacific rim's rating <= braveheart's rating -> 72 <= 78
      unless parent_node.nil? || parent_node.rating <= node.rating
        # Handle the parents
        grandparent = parent_node.parent
        parent_node.parent = node
        node.parent = grandparent

        # Handle the lefts
        node_left = node.left

        unless grandparent.nil?
          grandparent.left = node
        else
          @root = node
        end

        node.left = parent_node
        parent_node.left = node_left

        # Hangle the rights
        node_right = node.right

        unless grandparent.nil?
          grandparent.right = node
          node.right = parent_node
        else
          node.right = parent_node.right # this line is wrong for GP case
        end
        parent_node.right = node_right
      end
    end

    def delete(root, data)
      if root.nil? || data.nil?
        return nil
      end

      node = find(root,data)
    end

    # Recursive Depth First Search
    def find(root, data)
      if data.nil?
        return nil
      end

      if root.title == data
        return root
      end

      unless root.left.nil?
        answer = find(root.left, data)
        return answer unless answer == nil
      end

      unless root.right.nil?
        return find(root.right, data)
      end
    end

    def display_tree(node)
      return nil if node.nil?
      queue = Queue.new
      queue.enq(node)
      until queue.empty?
        value = queue.deq
        puts "#{value.title}: #{value.rating}" if value.valid?
        # keep moving the levels in tree by pushing left and right nodes of tree in queue
        queue.enq(value.left) if value.valid?
        queue.enq(value.right) if value.valid?
      end
    end
  end

# root = Node.new("The Matrix", 87)
#
# heap = MinHeap.new(root)
#
# p_rim = Node.new("Pacific Rim", 72)
# brave = Node.new("Braveheart", 78)
# jedi = Node.new("Star Wars: Return of the Jedi", 80)
# heap.insert(root, p_rim)
# byebug
# heap.insert(root, brave)
# byebug
# heap.insert(root, jedi)

end
