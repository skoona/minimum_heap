# Heaps

#### A min-heap is a binary tree data structure in which the data of each node is less than or equal to the data of that node’s children and the tree is complete.

#### Required Behaviors

A Binary Heap is a Binary Tree with following properties.
1) It’s a complete tree (All levels are completely filled except possibly the last level and the last level has all keys as left as possible). This property of Binary Heap makes them suitable to be stored in an array.
2) A Binary Heap is either Min Heap or Max Heap. In a Min Binary Heap, the key at root must be minimum among all keys present in Binary Heap. The same property must be recursively true for all nodes in Binary Tree. Max Binary Heap is similar to Min Heap.

3) All child nodes are larger than their parent
4) The smallest element of the min-heap is at the root
5) They can refer to another node to the left with a smaller value
6) They can refer to another node to the right with a larger value

Ref: http://www.geeksforgeeks.org/binary-heap/

To experiment with that code, run `bin/console` for an interactive prompt.


## Usage


```ruby
####
# Console Run
####
# root = Heaps::Node.new("The Matrix", 87)
# tree = Heaps::MinimumHeap.new(root)
# tree.insert Heaps::Node.new("Pacific Rim", 72)
# tree.insert Heaps::Node.new("Braveheart", 78)
# tree.insert Heaps::Node.new("Star Wars: Return of the Jedi", 80)
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

####
# Test Run
####
# Inserting Donnie Darko: 85
# Before: {87:{}|{}}
# TREE-NODE: {87:{}|{}}  ==> RowCalc: 1, Target: 1, Location: 1
# Swapping...
#     After: {85:{87:{}|{}}|{}}
# The Matrix: 87
# Donnie Darko: 85
# ==========
#     Inserting Inception: 86
# Before: {85:{87:{}|{}}|{}}
# TREE-NODE: {85:{87:{}|{}}|{}}  ==> RowCalc: 1, Target: 2, Location: 1
# After: {85:{87:{}|{}}|{86:{}|{}}}
# The Matrix: 87
# Donnie Darko: 85
# Inception: 86
# ==========
#     Inserting District 9: 90
# Before: {85:{87:{}|{}}|{86:{}|{}}}
# TREE-NODE: {86:{}|{}}  ==> RowCalc: 2, Target: 1, Location: 2
# After: {85:{87:{}|{}}|{86:{}|{90:{}|{}}}}
# The Matrix: 87
# Donnie Darko: 85
# Inception: 86
# District 9: 90
# ==========
#     Inserting Braveheart: 78
# Before: {85:{87:{}|{}}|{86:{}|{90:{}|{}}}}
# TREE-NODE: {87:{}|{}}  ==> RowCalc: 2, Target: 2, Location: 2
# Swapping...
#     After: {78:{85:{87:{}|{}}|{}}|{86:{}|{90:{}|{}}}}
# The Matrix: 87
# Donnie Darko: 85
# Braveheart: 78
# Inception: 86
# District 9: 90
# ==========
#     Inserting Star Wars: A New Hope: 93
# Before: {78:{85:{87:{}|{}}|{}}|{86:{}|{90:{}|{}}}}
# TREE-NODE: {86:{}|{90:{}|{}}}  ==> RowCalc: 2, Target: 3, Location: 2
# After: {78:{85:{87:{}|{}}|{}}|{86:{}|{90:{}|{93:{}|{}}}}}
# The Matrix: 87
# Donnie Darko: 85
# Braveheart: 78
# Inception: 86
# District 9: 90
# Star Wars: A New Hope: 93
# ==========
#     {78:{85:{87:{}|{}}|{}}|{86:{}|{90:{}|{93:{}|{}}}}}
#
#               Actual                   Desired
#                  78                       78
#                /   \                    /    \
#              85    86                 85     86
#             / \   / \                / \    / \
#           87        90              87 90  93
#                    / \
#                      93
#
####

 Ref: http://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/
   Depth First Traversals:
   (a) Inorder (Left, Root, Right) : 4 2 5 1 3
   (b) Preorder (Root, Left, Right) : 1 2 4 5 3
   (c) Postorder (Left, Right, Root) : 4 5 2 3 1

   Ref: http://www.geeksforgeeks.org/?p=2686
   Breadth First or Level Order Traversal : 1 2 3 4 5


 Refs:
   Balanced: http://www.geeksforgeeks.org/how-to-determine-if-a-binary-tree-is-balanced/


####
# Ideal Interface
####
class MinimumHeap
   def initialize(first_node)
   end
   def push(node)
   end
   def pop
   end
   def delete(node)
   end
   def min_node
   end
   def max_node
   end
   def size
   end
   def empty?
   end

   def include?(title|value)
   end
   def find_node(title|value)
   end
   def to_a(node=root)
   end
   def each(&block)
   end

   def display(node=root)
   end
   def inspect(node=root)
   end
end
   
```


## More background on the ```Heap Property```
A heap is an efficient semi-ordered data structure for storing a collection of orderable data. A min-heap supports two operations:

    INSERT(heap, element)
    element REMOVE_MIN(heap)

This chapter will refer exclusively to binary heaps, although different types of heaps exist. The term binary heap and heap are
interchangeable in most cases. A heap can be thought of as a tree with parent and child. The main difference between a heap and
a binary tree is the heap property. In order for a data structure to be considered a heap, it must satisfy the following
condition ```heap property```:

    If A and B are elements in the heap and B is a child of A, then key(A) ≤ key(B).
    (This property applies for a min-heap. A max heap would have the comparison reversed). What this tells us is that the minimum
    key will always remain at the top and greater values will be below it. Due to this fact, heaps are used to implement priority
    queues which allows quick access to the item with the most priority. Here's an example of a min-heap:

![Minimal-Heap](https://upload.wikimedia.org/wikipedia/commons/5/5c/Binary-heap.png)

    Description: Example of a complete binary max heap
        Date	8 December 2010
        Author	Ermishin

A heap is implemented using an array that is indexed from 1 to N, where N is the number of elements in the heap.

At any time, the heap must satisfy the heap property

        array[n] <= array[2*n]   // parent element <= left child
    and
        array[n] <= array[2*n+1] // parent element <= right child
![Arry Implementation](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Heap-as-array.svg/603px-Heap-as-array.svg.png)

    Description: Example of a complete binary max-heap with node keys being integers from 1 to 100 and how it would be stored in an array.
        Date	30 January 2017
        Author	Maxiantor

## Operations
Ref: https://en.wikipedia.org/wiki/Heap_(data_structure)
Ref: https://en.wikibooks.org/wiki/Data_Structures/Min_and_Max_Heaps

The common operations involving heaps are:

### Basic
find-max or find-min:
: find a maximum item of a max-heap, or a minimum item of a min-heap, respectively (a.k.a. peek)

insert:
: adding a new key to the heap (a.k.a., push[3])

extract-max [or extract-min]:
: returns the node of maximum value from a max heap [or minimum value from a min heap] after removing it from the heap (a.k.a., pop[4])

delete-max [or delete-min]:
: removing the root node of a max heap [or min heap], respectively

replace:
: pop root and push a new key. More efficient than pop followed by push, since only need to balance once, not twice, and appropriate for fixed-size heaps.[5]

### Creation
create-heap:
: create an empty heap

heapify:
: create a heap out of given array of elements

merge (union):
: joining two heaps to form a valid new heap containing all the elements of both, preserving the original heaps.

meld:
: joining two heaps to form a valid new heap containing all the elements of both, destroying the original heaps.

### Inspection
size:
: return the number of items in the heap.

is-empty:
: return true if the heap is empty, false otherwise.

### Internal
increase-key or decrease-key:
: updating a key within a max- or min-heap, respectively

delete:
: delete an arbitrary node (followed by moving last node and sifting to maintain heap)

sift-up:
: move a node up in the tree, as long as needed; used to restore heap condition after insertion. Called "sift" because node moves up the tree until it reaches the correct level, as in a sieve.

sift-down:
: move a node down in the tree, similar to sift-up; used to restore heap condition after deletion or replacement.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heaps'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heaps



## Development

Considerations: Navigation
    tree_node < new_node        :Left
    tree_node > new_node        :Move_Up
    tree_node.left < new_node   :Right
    tree_node.right > new_node  :Move_up
    

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/heaps. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

