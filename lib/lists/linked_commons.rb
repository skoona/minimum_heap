##
# File <root>/lib/lists/linked_commons.rb
#
# Common routines for Linked List:
#     #initialize, #first, #next, #current, #last, #at_index,
#     #insert, #prepend, #append, #empty?, #clear,
#     #each, #to_a, and #sort!
#
#   list = Lists::DoublyLinkedList.new(1,2,3,4)
#
#   value = list.first
#   value = list.next
#
##
#   Node Interface Special Methods called
#   from LinkNode to execute regular methods on other nodes
#
#     #node_request(method_sym=:current, *vargs, &block)          ==> node
#     #node_value_request(method_sym=:current, *vargs, &block)    ==> value or method return
##
#    node = Lists::DoublyLinkedList.call(1,2,3,4)
#
#    node = node.first_node
#    value = node.value
#    value = node.next_node.value
##


module Lists

  class LinkedCommons
    attr_accessor :size

    # Initialize and return first node if nodes are available, else class instance
    def self.call(*vargs, &compare_key_proc)
      target = self.new(*vargs, &compare_key_proc)
      return target.instance_variable_get(:@current) if vargs.size > 1
      target
    end

    def initialize(*vargs, &compare_key_proc)
      @current = nil
      @head = nil
      @tail = nil
      @size = 0

      @match_value     = block_given? ? compare_key_proc : lambda {|obj| obj }
      @sort_ascending  = lambda {|a_obj,b_obj| @match_value.call(a_obj) >= @match_value.call(b_obj)}
      @sort_descending = lambda {|a_obj,b_obj| @match_value.call(a_obj) <= @match_value.call(b_obj)}
      @sort_condition  = @sort_ascending

      vargs.each {|value| insert(value) }
      first if vargs.size > 1
    end


    # return values and position current to last node accessed
    # prevent @current from nil assignment
    def first
      @current = self.head if self.head
      @current.value rescue nil
    end

    def next
      @current = @current.next if @current and @current.next
      @current.value rescue nil
    end

    def current
      @current.value rescue nil
    end

    def last
      @current = self.tail if self.tail
      @current.value rescue nil
    end

    # return node at positive index from head
    def at_index(index)
      find_by_index(index)
      current
    end

    # Access to current node as anchor for Node based operations
    # if initialized without vargs, this is only way to access a node
    def nodes
      @current
    end

    def empty?
      self.size == 0
    end

    # return number cleared
    def clear
      rc = 0
      node = self.head
      position = node
      while node do
        node = node.remove!
        rc += 1
        break if position.equal?(node)
      end

      @current = nil
      self.head = nil
      self.tail = nil
      self.size = 0
      rc
    end

    # return new size
    def prepend(value)
      temp = self.head.value rescue nil
      insert_before(temp, value)
    end

    #
    # Enumerate
    #

    # perform each() or return enumerator
    def each(&block)
      @current = self.head
      position = @current
      if block_given?
        while position do
          block.call( position.value.dup )
          position = position.next
          break if position.equal?(@current)
        end
      else
        Enumerator.new do |yielder|
          while position do
            yielder << position.value.dup
            position = position.next
            break if position.equal?(@current)
          end
        end
      end
    end

    # convert self to a value array
    def to_a
      @current = self.head
      position = self.head
      result = []
      while position do
        result << position.value.dup
        position = position.next
        break if position.equal?(@current)
      end
      result
    end

    # block format: sort condition : {|a_obj,b_obj| a_obj >= b_obj}
    def sort!(direction_sym=:default, &compare_sort_proc)
      @active_sort_condition = block_given? ? compare_sort_proc :
                                   case direction_sym
                                     when :asc
                                       @sort_ascending
                                     when :desc
                                       @sort_descending
                                     else
                                       @sort_condition
                                   end
      sorted = merge_sort(self.to_a)
      clear
      sorted.each {|item| insert(item) }
      self.size
    end


  protected

    attr_accessor :head, :tail

    # scan for first occurance of matching value
    def find_by_value(value)
      return nil if value.nil? || self.size == 0
      stop_node = self.head
      target = stop_node
      while target && !target.match_by_value(value)
        target = target.next
        break if stop_node.equal?(target)
      end
      target = nil unless target && target.match_by_value(value)
      target
    end

    # Merged Sort via Ref: http://rubyalgorithms.com/merge_sort.html
    # arr is Array to be sorted, sort_cond is Proc expecting a/b params returning true/false
    def merge_sort(arr)
      return arr if arr.size < 2
      middle = arr.size / 2
      left = merge_sort(arr[0...middle])
      right = merge_sort(arr[middle..arr.size])
      merge(left, right)
    end

    def merge(left, right)
      sorted = []
      while left.any? && right.any?
        if @active_sort_condition.call(left.first, right.first)
          sorted.push right.shift
        else
          sorted.push left.shift
        end
      end

      sorted + left + right
    end

  end
end # module
