# Heaps

#### A min-heap is a binary tree data structure in which the data of each node is less than or equal to the data of that node’s children and the tree is complete.

#### Required Behaviors

A Binary Heap is a Binary Tree with following properties.
1) It’s a complete tree (All levels are completely filled except possibly the last level and the last level has all keys as left as possible). This property of Binary Heap makes them suitable to be stored in an array.

2) A Binary Heap is either Min Heap or Max Heap. In a Min Binary Heap, the key at root must be minimum among all keys present in Binary Heap. The same property must be recursively true for all nodes in Binary Tree. Max Binary Heap is similar to Min Heap.

* All child nodes are larger than their parent
* The smallest element of the min-heap is at the root
* They can refer to another node to the left with a smaller value
* They can refer to another node to the right with a larger value

* The children of an element at a given index i will always be in 2i and 2i + 1.
* The parent of a node will be at the index i/2.
* A binary tree is a ***complete*** if all levels are completely filled except possibly the last level and the last level has all keys as left as possible.

Ref: http://www.geeksforgeeks.org/binary-heap/

To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heaps'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heaps

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/heaps. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

