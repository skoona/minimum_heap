##
# File: <root>/lib/minimum_heap.rb


# A min-heap is a binary tree data structure in which the data of each node is less than or
# equal to the data of that node’s children and the tree is complete.

# - All child nodes are larger than their parent
# - The smallest element of the min-heap is at the root
# - They can refer to another node to the left with a smaller value
# - They can refer to another node to the right with a larger value

require "heaps/version"
require "heaps/empty_node"
require "heaps/node"

module Heaps

  class MinimumHeap
    attr_reader :root
    attr_reader :count

    def initialize(initial_root)
      @root = initial_root
      @count = 1
      @position = 1
    end

    # root must be lowest rating
    # Parents must be lower rating than children
    # - test for lower than root
    # - search row-wise for available slot with parent less than new-node - insert
    # - re-shuffle to make tree Complete
    def insert(node)
      return if node.nil?
      puts "Inserting #{node.title}: #{node.rating}"
      @count += 1

      puts "\tBefore: #{root.inspect}"

      tree_node = find_insert_positon(node)
      if node.rating < root.rating
        puts "Swapping..."
        root_swap(node)
      else
        tree_node.insert(node)
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
        tree_node = case tree_node <=> node
                      when 1
                        tree_node.left.valid? ?
                            tree_node.left  :
                            break;
                      when -1
                        tree_node.right.valid? ?
                            tree_node.right  :
                            break
                      else break
                    end
        tree_index += 1                       # tree_index == row_number
      end

      # either leaf or tree > node
      puts "TREE-NODE: #{tree_node.inspect}  ==> RowCalc: #{row_number}, Target: #{target_location}, Location: #{tree_index}"

      tree_node
    end

    def root_swap(node)
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
    end

    def display_tree(node=@root)
      node.to_a.each do |item|
        puts item
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
