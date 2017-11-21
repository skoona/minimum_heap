# Heaps

#### A min-heap is a binary tree data structure in which the data of each node is less than or equal to the data of that node’s children and the tree is complete.

#### Required Behaviors

A Binary Heap is a Binary Tree with following properties.
1) It’s a complete tree (All levels are completely filled except possibly the last level and the last level has all keys as left as possible). This property of Binary Heap makes them suitable to be stored in an array.
2) A Binary Heap is either Min Heap or Max Heap. In a Min Binary Heap, the key at root must be minimum among all keys present in Binary Heap. The same property must be recursively true for all nodes in Binary Tree. Max Binary Heap is similar to Min Heap.

3) All child nodes are larger than their parent
4) The smallest element of the min-heap is at the root
5) The left child of a parent is less than the right child of same parent

Ref: http://www.geeksforgeeks.org/binary-heap/
Ref: https://en.wikipedia.org/wiki/Heap_(data_structure)
Ref: https://en.wikibooks.org/wiki/Data_Structures/Min_and_Max_Heaps

To experiment with this code, execute `bin/console` for an interactive prompt.


## Usage


```ruby
####
# Console Run
####
[jscott@imac MinimumHeap]$ bin/console

[1] pry(main)> heap = Heaps::MinimumHeap.new([{:label=>"Star Trek: Next Generation", :value=>102}, {:label=>"The Matrix", :value=>70}, {:label=>"Pacific Rim", :value=>72},
        {:label=>"Star Wars: Return of the Jedi", :value=>80}, {:label=>"Mad Max 2: The Road Warrior", :value=>98}, {:label=>"The Shawshank Redemption", :value=>91},
        {:label=>"Donnie Darko", :value=>85}, {:label=>"Star Wars: A New Hope", :value=>93}, {:label=>"Star Wars: The Empire Strikes Back", :value=>94}, {:label=>"Braveheart", :value=>78},
        {:label=>"Inception", :value=>86}, {:label=>"Star Trek: Voyager", :value=>100}, {:label=>"Star Trek: Star Trek", :value=>99}, {:label=>"District 9", :value=>90},
        {:label=>"Star Trek: Deep Space 9", :value=>101}, {:label=>"The Martian", :value=>92}])
push Inserted at R/C/mR/cT => [0, 1, 1, 1], Root.Node => {:label=>"Star Trek: Next Generation", :value=>102}, Node.Parent => {:label=>"Heaps::EmptyNode", :value=>-1}
push Inserted at R/C/mR/cT => [1, 1, 2, 3], Node => {:label=>"The Matrix", :value=>70}, Node.Parent => {:label=>"Heaps::EmptyNode", :value=>-1}
push Inserted at R/C/mR/cT => [1, 2, 2, 3], Node => {:label=>"Pacific Rim", :value=>72}, Node.Parent => {:label=>"The Matrix", :value=>70}
push Inserted at R/C/mR/cT => [2, 1, 4, 7], Node => {:label=>"Star Wars: Return of the Jedi", :value=>80}, Node.Parent => {:label=>"Pacific Rim", :value=>72}
push Inserted at R/C/mR/cT => [2, 2, 4, 7], Node => {:label=>"Mad Max 2: The Road Warrior", :value=>98}, Node.Parent => {:label=>"Pacific Rim", :value=>72}
push Inserted at R/C/mR/cT => [2, 3, 4, 7], Node => {:label=>"The Shawshank Redemption", :value=>91}, Node.Parent => {:label=>"The Matrix", :value=>70}
push Inserted at R/C/mR/cT => [2, 4, 4, 7], Node => {:label=>"Donnie Darko", :value=>85}, Node.Parent => {:label=>"The Matrix", :value=>70}
push Inserted at R/C/mR/cT => [3, 1, 8, 15], Node => {:label=>"Star Wars: A New Hope", :value=>93}, Node.Parent => {:label=>"Star Wars: Return of the Jedi", :value=>80}
push Inserted at R/C/mR/cT => [3, 2, 8, 15], Node => {:label=>"Star Wars: The Empire Strikes Back", :value=>94}, Node.Parent => {:label=>"Star Wars: Return of the Jedi", :value=>80}
push Inserted at R/C/mR/cT => [3, 3, 8, 15], Node => {:label=>"Braveheart", :value=>78}, Node.Parent => {:label=>"Pacific Rim", :value=>72}
push Inserted at R/C/mR/cT => [3, 4, 8, 15], Node => {:label=>"Inception", :value=>86}, Node.Parent => {:label=>"Star Wars: Return of the Jedi", :value=>80}
push Inserted at R/C/mR/cT => [3, 5, 8, 15], Node => {:label=>"Star Trek: Voyager", :value=>100}, Node.Parent => {:label=>"The Shawshank Redemption", :value=>91}
push Inserted at R/C/mR/cT => [3, 6, 8, 15], Node => {:label=>"Star Trek: Star Trek", :value=>99}, Node.Parent => {:label=>"The Shawshank Redemption", :value=>91}
push Inserted at R/C/mR/cT => [3, 7, 8, 15], Node => {:label=>"District 9", :value=>90}, Node.Parent => {:label=>"Donnie Darko", :value=>85}
push Inserted at R/C/mR/cT => [3, 8, 8, 15], Node => {:label=>"Star Trek: Deep Space 9", :value=>101}, Node.Parent => {:label=>"The Shawshank Redemption", :value=>91}
push Inserted at R/C/mR/cT => [4, 1, 16, 31], Node => {:label=>"The Martian", :value=>92}, Node.Parent => {:label=>"Braveheart", :value=>78}
=> {70:{72:{78:{92:{93:{}|{}}|{}}|{94:{}|{}}}|{80:{86:{}|{}}|{98:{}|{}}}}|{85:{90:{99:{}|{}}|{100:{}|{}}}|{91:{101:{}|{}}|{102:{}|{}}}}}

[2] pry(main)> heap.peek
=> {:label=>"The Matrix", :value=>70}

[3] pry(main)> heap.last_node
=> {93:{}|{}}

[4] pry(main)> heap.root
=> {70:{72:{78:{92:{93:{}|{}}|{}}|{94:{}|{}}}|{80:{86:{}|{}}|{98:{}|{}}}}|{85:{90:{99:{}|{}}|{100:{}|{}}}|{91:{101:{}|{}}|{102:{}|{}}}}}

[5] pry(main)> heap.to_a
=> [{:label=>"The Matrix", :value=>70},
 {:label=>"Pacific Rim", :value=>72},
 {:label=>"Braveheart", :value=>78},
 {:label=>"The Martian", :value=>92},
 {:label=>"Star Wars: A New Hope", :value=>93},
 {:label=>"Star Wars: The Empire Strikes Back", :value=>94},
 {:label=>"Star Wars: Return of the Jedi", :value=>80},
 {:label=>"Inception", :value=>86},
 {:label=>"Mad Max 2: The Road Warrior", :value=>98},
 {:label=>"Donnie Darko", :value=>85},
 {:label=>"District 9", :value=>90},
 {:label=>"Star Trek: Star Trek", :value=>99},
 {:label=>"Star Trek: Voyager", :value=>100},
 {:label=>"The Shawshank Redemption", :value=>91},
 {:label=>"Star Trek: Deep Space 9", :value=>101},
 {:label=>"Star Trek: Next Generation", :value=>102}]

[6] pry(main)> heap.root.dfs_preorder([])
NoMethodError: undefined method `dfs_preorder' for #<Heaps::Node:0x007fa1e6279338>
Did you mean?  dfs_pre_order
from (pry):6:in `__pry__'

[7] pry(main)> heap.root.dfs_pre_order([])
=> [{:label=>"The Matrix", :value=>70},
 {:label=>"Pacific Rim", :value=>72},
 {:label=>"Braveheart", :value=>78},
 {:label=>"The Martian", :value=>92},
 {:label=>"Star Wars: A New Hope", :value=>93},
 {:label=>"Star Wars: The Empire Strikes Back", :value=>94},
 {:label=>"Star Wars: Return of the Jedi", :value=>80},
 {:label=>"Inception", :value=>86},
 {:label=>"Mad Max 2: The Road Warrior", :value=>98},
 {:label=>"Donnie Darko", :value=>85},
 {:label=>"District 9", :value=>90},
 {:label=>"Star Trek: Star Trek", :value=>99},
 {:label=>"Star Trek: Voyager", :value=>100},
 {:label=>"The Shawshank Redemption", :value=>91},
 {:label=>"Star Trek: Deep Space 9", :value=>101},
 {:label=>"Star Trek: Next Generation", :value=>102}]

[8] pry(main)> heap.pop
Removing Node: {:label=>"The Matrix", :value=>70}
=> {:label=>"The Matrix", :value=>70}

[9] pry(main)> heap.inspect
=> "{72:{78:{80:{92:{}|{}}|{94:{}|{}}}|{85:{86:{}|{}}|{98:{}|{}}}}|{90:{91:{99:{}|{}}|{100:{}|{}}}|{93:{101:{}|{}}|{102:{}|{}}}}}"

[10] pry(main)> heap.pop
Removing Node: {:label=>"Pacific Rim", :value=>72}
=> {:label=>"Pacific Rim", :value=>72}

[11] pry(main)> heap.inspect
=> "{78:{80:{85:{92:{}|{}}|{94:{}|{}}}|{86:{90:{}|{}}|{98:{}|{}}}}|{91:{93:{99:{}|{}}|{100:{}|{}}}|{101:{102:{}|{}}|{}}}}"

[12] pry(main)> heap.pop
Removing Node: {:label=>"Braveheart", :value=>78}
=> {:label=>"Braveheart", :value=>78}

[13] pry(main)> heap.inspect
=> "{80:{85:{86:{92:{}|{}}|{94:{}|{}}}|{90:{91:{}|{}}|{98:{}|{}}}}|{93:{99:{100:{}|{}}|{101:{}|{}}}|{102:{}|{}}}}"

[14] pry(main)> heap.pop
Removing Node: {:label=>"Star Wars: Return of the Jedi", :value=>80}
=> {:label=>"Star Wars: Return of the Jedi", :value=>80}

[15] pry(main)> heap.inspect
=> "{85:{86:{90:{92:{}|{}}|{94:{}|{}}}|{91:{93:{}|{}}|{98:{}|{}}}}|{99:{100:{101:{}|{}}|{102:{}|{}}}|{}}}"

[16] pry(main)> heap.pop
Removing Node: {:label=>"Donnie Darko", :value=>85}
=> {:label=>"Donnie Darko", :value=>85}

[17] pry(main)> heap.inspect
=> "{86:{90:{91:{92:{}|{}}|{94:{}|{}}}|{93:{98:{}|{}}|{99:{}|{}}}}|{100:{101:{102:{}|{}}|{}}|{}}}"

[18] pry(main)> heap.pop
Removing Node: {:label=>"Inception", :value=>86}
=> {:label=>"Inception", :value=>86}

[19] pry(main)> heap.inspect
=> "{90:{91:{92:{93:{}|{}}|{94:{}|{}}}|{98:{99:{}|{}}|{100:{}|{}}}}|{101:{102:{}|{}}|{}}}"

[20] pry(main)> heap.pop
Removing Node: {:label=>"District 9", :value=>90}
=> {:label=>"District 9", :value=>90}

[21] pry(main)> heap.inspect
=> "{91:{92:{93:{94:{}|{}}|{98:{}|{}}}|{99:{100:{}|{}}|{101:{}|{}}}}|{102:{}|{}}}"

[22] pry(main)> heap.pop
Removing Node: {:label=>"The Shawshank Redemption", :value=>91}
=> {:label=>"The Shawshank Redemption", :value=>91}

[23] pry(main)> heap.inspect
=> "{92:{93:{94:{98:{}|{}}|{99:{}|{}}}|{100:{101:{}|{}}|{102:{}|{}}}}|{}}"

[24] pry(main)> heap.pop
Removing Node: {:label=>"The Martian", :value=>92}
=> {:label=>"The Martian", :value=>92}

[25] pry(main)> heap.inspect
=> "{93:{94:{98:{99:{}|{}}|{100:{}|{}}}|{101:{102:{}|{}}|{}}}|{}}"

[26] pry(main)> heap.pop
Removing Node: {:label=>"Star Wars: A New Hope", :value=>93}
=> {:label=>"Star Wars: A New Hope", :value=>93}

[27] pry(main)> heap.inspect
=> "{94:{98:{99:{100:{}|{}}|{101:{}|{}}}|{102:{}|{}}}|{}}"

[28] pry(main)> heap.pop
Removing Node: {:label=>"Star Wars: The Empire Strikes Back", :value=>94}
=> {:label=>"Star Wars: The Empire Strikes Back", :value=>94}

[29] pry(main)> heap.inspect
=> "{98:{99:{100:{101:{}|{}}|{102:{}|{}}}|{}}|{}}"

[30] pry(main)> heap.pop
Removing Node: {:label=>"Mad Max 2: The Road Warrior", :value=>98}
=> {:label=>"Mad Max 2: The Road Warrior", :value=>98}

[31] pry(main)> heap.inspect
=> "{99:{100:{101:{102:{}|{}}|{}}|{}}|{}}"

[32] pry(main)> heap.pop
Removing Node: {:label=>"Star Trek: Star Trek", :value=>99}
=> {:label=>"Star Trek: Star Trek", :value=>99}

[33] pry(main)> heap.inspect
=> "{100:{101:{102:{}|{}}|{}}|{}}"

[34] pry(main)>


 Ref: http://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/
   Depth First Traversals:
   (a) Inorder   (Left, Root, Right) : 4 2 5 1 3
   (b) Preorder  (Root, Left, Right) : 1 2 4 5 3
   (c) Postorder (Left, Right, Root) : 4 5 2 3 1

   Ref: http://www.geeksforgeeks.org/?p=2686
   Breadth First or Level Order Traversal : 1 2 3 4 5


 Refs:
   Balanced: http://www.geeksforgeeks.org/how-to-determine-if-a-binary-tree-is-balanced/


####
# Ideal Interface
# - EmptyNode
# - Node
####
class MinimumHeap
   def self.heapify(*user_data_ary)
   end
   def initialize(*args)
   end

   def push(user_data)     | alias #<<
   end
   def pop
   end
   def peek
   end
   def include?(user_data)
   end

   def replace!(user_data)
   end
   def delete!(user_data)
   end

   def merge(other_heap)
   end
   def merge!(other_heap)
   end
   def union!(other_heap)
   end

   def clear!
   end
   def size     | alias #length
   end
   def empty?
   end
   def to_a
   end
   def display
   end
   def inspect  | alias #to_s
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


After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skoona/heaps. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

