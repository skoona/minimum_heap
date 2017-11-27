# Minimum Heap

A Minimum Heap is a binary tree data structure in which the data of each node is less than or equal to the data of that node’s children and the tree is complete.

Heaps are an efficient semi-ordered data structure for storing a collection of orderable data. The term binary heap
and heap are interchangeable in most cases. A heap can be thought of as a tree with parent and child. The main
difference between a heap and a binary tree is the heap property. In order for a data structure to be considered
a heap, it must satisfy the following condition ```heap property```:

* If A and B are elements in the heap and B is a child of A, then key(A) ≤ key(B).
![Minimal-Heap](https://upload.wikimedia.org/wikipedia/commons/5/5c/Binary-heap.png)

    Description: Example of a complete binary min heap
        Date	8 December 2010
        Author	Ermishin

#### Required Behaviors

A Binary Heap is a Binary Tree with following properties.

* It’s a complete tree (All levels are completely filled except possibly the last level and the last level has all keys as left as possible). This property of Binary Heap makes them suitable to be stored in an array.
* A Binary Heap is either Min Heap or Max Heap. In a Min Binary Heap, the key at root must be minimum among all keys present in Binary Heap. The same property must be recursively true for all nodes in Binary Tree. Max Binary Heap is similar to Min Heap.
* All child nodes are larger than their parent
* The smallest element of the min-heap is at the root
* The left child of a parent is less than the right child of same parent

```ruby
Ref: https://medium.freecodecamp.org/all-you-need-to-know-about-tree-data-structures-bceacb85490c
Ref: http://www.geeksforgeeks.org/binary-heap/
Ref: https://en.wikipedia.org/wiki/Heap_(data_structure)
Ref: https://en.wikibooks.org/wiki/Data_Structures/Min_and_Max_Heaps
Ref: http://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/
Ref: http://www.geeksforgeeks.org/how-to-determine-if-a-binary-tree-is-balanced/
Ref: http://www.geeksforgeeks.org/?p=2686
```

    Depth First Traversals:
      (a) Inorder   (Left, Root, Right) : 4 2 5 1 3
      (b) Preorder  (Root, Left, Right) : 1 2 4 5 3
      (c) Postorder (Left, Right, Root) : 4 5 2 3 1
    Breadth First Traversals (By Level) : 1 2 3 4 5

### Observations
* The implied `ascending order` of a minimum heap is only seen in the sequence presented with each root node removal.
* Once loaded the useable apis are `pop` or removal, and potentially `empty`.
* `has_more_items`, `next`, and `size` would seem to be a useful set of methods but are never mentioned.


## Usage
To experiment with this code, execute `bin/console` for an interactive prompt.


```ruby
####
# Interactive Console Run
####
[jscott@imac MinimumHeap]$ bin/console

[1] pry(main)> heap = Heaps::MinHeap.new([{:description=>"Star Trek: Next Generation", :value=>102}, {:description=>"The Matrix", :value=>70}, {:description=>"Pacific Rim", :value=>72},
        {:description=>"Star Wars: Return of the Jedi", :value=>80}, {:description=>"Mad Max 2: The Road Warrior", :value=>98}, {:description=>"The Shawshank Redemption", :value=>91},
        {:description=>"Donnie Darko", :value=>85}, {:description=>"Star Wars: A New Hope", :value=>93}, {:description=>"Star Wars: The Empire Strikes Back", :value=>94}, {:description=>"Braveheart", :value=>78},
        {:description=>"Inception", :value=>86}, {:description=>"Star Trek: Voyager", :value=>100}, {:description=>"Star Trek: Star Trek", :value=>99}, {:description=>"District 9", :value=>90},
        {:description=>"Star Trek: Deep Space 9", :value=>101}, {:description=>"The Martian", :value=>92}])
push Inserted at R/C/mR/cT => [0, 1, 1, 1], Root.Node => {:description=>"Star Trek: Next Generation", :value=>102}, Node.Parent => {:description=>"Heaps::EmptyNode", :value=>-1}
push Inserted at R/C/mR/cT => [1, 1, 2, 3], Node => {:description=>"The Matrix", :value=>70}, Node.Parent => {:description=>"Heaps::EmptyNode", :value=>-1}
push Inserted at R/C/mR/cT => [1, 2, 2, 3], Node => {:description=>"Pacific Rim", :value=>72}, Node.Parent => {:description=>"The Matrix", :value=>70}
push Inserted at R/C/mR/cT => [2, 1, 4, 7], Node => {:description=>"Star Wars: Return of the Jedi", :value=>80}, Node.Parent => {:description=>"Pacific Rim", :value=>72}
push Inserted at R/C/mR/cT => [2, 2, 4, 7], Node => {:description=>"Mad Max 2: The Road Warrior", :value=>98}, Node.Parent => {:description=>"Pacific Rim", :value=>72}
push Inserted at R/C/mR/cT => [2, 3, 4, 7], Node => {:description=>"The Shawshank Redemption", :value=>91}, Node.Parent => {:description=>"The Matrix", :value=>70}
push Inserted at R/C/mR/cT => [2, 4, 4, 7], Node => {:description=>"Donnie Darko", :value=>85}, Node.Parent => {:description=>"The Matrix", :value=>70}
push Inserted at R/C/mR/cT => [3, 1, 8, 15], Node => {:description=>"Star Wars: A New Hope", :value=>93}, Node.Parent => {:description=>"Star Wars: Return of the Jedi", :value=>80}
push Inserted at R/C/mR/cT => [3, 2, 8, 15], Node => {:description=>"Star Wars: The Empire Strikes Back", :value=>94}, Node.Parent => {:description=>"Star Wars: Return of the Jedi", :value=>80}
push Inserted at R/C/mR/cT => [3, 3, 8, 15], Node => {:description=>"Braveheart", :value=>78}, Node.Parent => {:description=>"Pacific Rim", :value=>72}
push Inserted at R/C/mR/cT => [3, 4, 8, 15], Node => {:description=>"Inception", :value=>86}, Node.Parent => {:description=>"Star Wars: Return of the Jedi", :value=>80}
push Inserted at R/C/mR/cT => [3, 5, 8, 15], Node => {:description=>"Star Trek: Voyager", :value=>100}, Node.Parent => {:description=>"The Shawshank Redemption", :value=>91}
push Inserted at R/C/mR/cT => [3, 6, 8, 15], Node => {:description=>"Star Trek: Star Trek", :value=>99}, Node.Parent => {:description=>"The Shawshank Redemption", :value=>91}
push Inserted at R/C/mR/cT => [3, 7, 8, 15], Node => {:description=>"District 9", :value=>90}, Node.Parent => {:description=>"Donnie Darko", :value=>85}
push Inserted at R/C/mR/cT => [3, 8, 8, 15], Node => {:description=>"Star Trek: Deep Space 9", :value=>101}, Node.Parent => {:description=>"The Shawshank Redemption", :value=>91}
push Inserted at R/C/mR/cT => [4, 1, 16, 31], Node => {:description=>"The Martian", :value=>92}, Node.Parent => {:description=>"Braveheart", :value=>78}
=> {70:{72:{78:{92:{93:{}|{}}|{}}|{94:{}|{}}}|{80:{86:{}|{}}|{98:{}|{}}}}|{85:{90:{99:{}|{}}|{100:{}|{}}}|{91:{101:{}|{}}|{102:{}|{}}}}}

[2] pry(main)> heap.peek
=> {:description=>"The Matrix", :value=>70}

[3] pry(main)> heap
=> {70:{72:{78:{92:{93:{}|{}}|{}}|{94:{}|{}}}|{80:{86:{}|{}}|{98:{}|{}}}}|{85:{90:{99:{}|{}}|{100:{}|{}}}|{91:{101:{}|{}}|{102:{}|{}}}}}

[4] pry(main)> heap.to_a
=> [{:description=>"The Matrix", :value=>70},
 {:description=>"Pacific Rim", :value=>72},
 {:description=>"Braveheart", :value=>78},
 {:description=>"The Martian", :value=>92},
 {:description=>"Star Wars: A New Hope", :value=>93},
 {:description=>"Star Wars: The Empire Strikes Back", :value=>94},
 {:description=>"Star Wars: Return of the Jedi", :value=>80},
 {:description=>"Inception", :value=>86},
 {:description=>"Mad Max 2: The Road Warrior", :value=>98},
 {:description=>"Donnie Darko", :value=>85},
 {:description=>"District 9", :value=>90},
 {:description=>"Star Trek: Star Trek", :value=>99},
 {:description=>"Star Trek: Voyager", :value=>100},
 {:description=>"The Shawshank Redemption", :value=>91},
 {:description=>"Star Trek: Deep Space 9", :value=>101},
 {:description=>"Star Trek: Next Generation", :value=>102}]

[6] pry(main)> heap.pop
Removing Node: {:description=>"The Matrix", :value=>70}
=> {:description=>"The Matrix", :value=>70, payload: {} }}

[7] pry(main)> heap.inspect
=> "{72:{78:{80:{92:{}|{}}|{94:{}|{}}}|{85:{86:{}|{}}|{98:{}|{}}}}|{90:{91:{99:{}|{}}|{100:{}|{}}}|{93:{101:{}|{}}|{102:{}|{}}}}}"

[8] pry(main)> heap.pop
Removing Node: {:description=>"Pacific Rim", :value=>72}
=> {:description=>"Pacific Rim", :value=>72, payload: {} }

[9] pry(main)> heap.inspect
=> "{78:{80:{85:{92:{}|{}}|{94:{}|{}}}|{86:{90:{}|{}}|{98:{}|{}}}}|{91:{93:{99:{}|{}}|{100:{}|{}}}|{101:{102:{}|{}}|{}}}}"

[10] pry(main)> heap.pop
Removing Node: {:description=>"Braveheart", :value=>78}
=> {:description=>"Braveheart", :value=>78, payload: {} }

[11] pry(main)> heap.inspect
=> "{80:{85:{86:{92:{}|{}}|{94:{}|{}}}|{90:{91:{}|{}}|{98:{}|{}}}}|{93:{99:{100:{}|{}}|{101:{}|{}}}|{102:{}|{}}}}"

[12] pry(main)> heap.pop
Removing Node: {:description=>"Star Wars: Return of the Jedi", :value=>80}
=> {:description=>"Star Wars: Return of the Jedi", :value=>80, payload: {} }

[13] pry(main)> heap.inspect
=> "{85:{86:{90:{92:{}|{}}|{94:{}|{}}}|{91:{93:{}|{}}|{98:{}|{}}}}|{99:{100:{101:{}|{}}|{102:{}|{}}}|{}}}"

[14] pry(main)> heap.pop
Removing Node: {:description=>"Donnie Darko", :value=>85}
=> {:description=>"Donnie Darko", :value=>85, payload: {} }

[15] pry(main)> heap.inspect
=> "{86:{90:{91:{92:{}|{}}|{94:{}|{}}}|{93:{98:{}|{}}|{99:{}|{}}}}|{100:{101:{102:{}|{}}|{}}|{}}}"

[16] pry(main)> heap.pop
Removing Node: {:description=>"Inception", :value=>86}
=> {:description=>"Inception", :value=>86, payload: {} }

[17] pry(main)> heap.inspect
=> "{90:{91:{92:{93:{}|{}}|{94:{}|{}}}|{98:{99:{}|{}}|{100:{}|{}}}}|{101:{102:{}|{}}|{}}}"

[18] pry(main)> heap.pop
Removing Node: {:description=>"District 9", :value=>90}
=> {:description=>"District 9", :value=>90, payload: {} }

[19] pry(main)> heap.inspect
=> "{91:{92:{93:{94:{}|{}}|{98:{}|{}}}|{99:{100:{}|{}}|{101:{}|{}}}}|{102:{}|{}}}"

[20] pry(main)> heap.pop
Removing Node: {:description=>"The Shawshank Redemption", :value=>91}
=> {:description=>"The Shawshank Redemption", :value=>91, payload: {} }

[21] pry(main)> heap.inspect
=> "{92:{93:{94:{98:{}|{}}|{99:{}|{}}}|{100:{101:{}|{}}|{102:{}|{}}}}|{}}"

[22] pry(main)> heap.pop
Removing Node: {:description=>"The Martian", :value=>92}
=> {:description=>"The Martian", :value=>92, payload: {} }

[23] pry(main)> heap.inspect
=> "{93:{94:{98:{99:{}|{}}|{100:{}|{}}}|{101:{102:{}|{}}|{}}}|{}}"

[24] pry(main)> heap.pop
Removing Node: {:description=>"Star Wars: A New Hope", :value=>93}
=> {:description=>"Star Wars: A New Hope", :value=>93, payload: {} }

[25] pry(main)> heap.inspect
=> "{94:{98:{99:{100:{}|{}}|{101:{}|{}}}|{102:{}|{}}}|{}}"

[26] pry(main)> heap.pop
Removing Node: {:description=>"Star Wars: The Empire Strikes Back", :value=>94}
=> {:description=>"Star Wars: The Empire Strikes Back", :value=>94, payload: {} }

[27] pry(main)> heap.inspect
=> "{98:{99:{100:{101:{}|{}}|{102:{}|{}}}|{}}|{}}"

[28] pry(main)> heap.pop
Removing Node: {:description=>"Mad Max 2: The Road Warrior", :value=>98}
=> {:description=>"Mad Max 2: The Road Warrior", :value=>98, payload: {} }

[29] pry(main)> heap.inspect
=> "{99:{100:{101:{102:{}|{}}|{}}|{}}|{}}"

[30] pry(main)> heap.pop
Removing Node: {:description=>"Star Trek: Star Trek", :value=>99}
=> {:description=>"Star Trek: Star Trek", :value=>99, payload: {} }

[31] pry(main)> heap.inspect
=> "{100:{101:{102:{}|{}}|{}}|{}}"

[32] pry(main)> quit
$


##
# Run Tests
##
$ bundle exec rspec
$ open docs/rspec.html
$ open coverage/index.html
$ bin/bench_heaps
$ bin/nodes

# Resources
# Class
# - MinHeap
# - MaxHeap
##
# Useage:
#
#      heap = Heaps::MinHeap.new   |      heap = Heaps::MaxHeap.new
#
#               heap.push("label-text", 12, SomeObjectOrDataPayload)
#               heap.push("label-text", 45, SomeObjectOrDataPayload)
#               while heap.size do
#                 heap.pop
#               end
#
# Heap will be empty, as #pop deletes each node returned
##

####
# Ideal Interface
# - EmptyNode
# - Node
# - UserData | user_data default ['Label String', int]
#   * Examples:
#   *          ['Movie Title", 12]
#   *          [ ['Movie Title", 12], ... ]
#   *          [ {description: 'Movie Title", value: 12, payload: any-type-of-data} }, ... ]
#   *          [ Heaps::Node.new('Movie Title", 12, any-type-of-data), ... ]
####
module Heaps
    class MinHeap
       def self.heapify(user_data_ary)
       end
       def initialize(args=[])
       end

       def push(user_data)     | alias #<<
       end
       def peek
       end
       def include?(user_data)
       end

       def pop
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
end
```

## Operations
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


## Gem Installation

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


## Build

1. $ git clone git@github.com:skoona/minimum_heap.git
2. $ cd minimum_heap
3. $ gem install bundler
4. $ bin/setup
5. $ bundle exec rspec
6. $ gem build heaps.gemspec
7. $ gem install heaps
* Done


## Contributing

Bug reports and pull requests are welcome on GitHub at  https://skoona.github.io/minimum_heap/. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

