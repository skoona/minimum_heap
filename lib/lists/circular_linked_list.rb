##
# File <root>/lib/lists/circular_linked_list.rb
#
#     ll = Lists::CircularLinkedList.new(*vargs, &compare_key_proc)
# - or -
#     ll = Lists::CircularLinkedList.new(1,2,3,4,5) {|element| element[:key] }
# - or -
#     ll = Lists::CircularLinkedList.new(
#                     {key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}
#          ) {|el| el[:key] }
# - or -
#     cmp_proc = lambda { |el| el[:key] }
#     vargs = [{key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}]
#     ll = Lists::CircularLinkedList.new(*vargs, &cmp_proc)
###
# value = ll.first
# value = ll.at_index(4)
# count = ll.insert({key: 'anyValue'})
# ...
# count = ll.sort!           -- defaults to :asc
# count = ll.sort!(:desc)
# count = ll.sort!() {|a,b| a[:key] <= b[:key] }
##


module Lists
  # Circularly Linked List
  # Forward (#next) and Backwards (#prev) navigation
  # No Head or Tail

  # LinkedCommons provides;
  # - #initialize, #first, #next, #current, #last, #at_index,
  #   #insert, #prepend, #append, #empty?, #clear,
  #   #each, #to_a, and #sort!
  #
  class CircularLinkedList < LinkedCommons

    #
    # Navigation
    #


    def prev
      @current = @current.prev if @current and @current.prev
      @current.value rescue nil
    end

    # -+ int position from current node
    def nth(index)
      node = @current
      position = node
      if index > 0
        while index > 1 and node and node.next
          node = node.next
          index -= 1
          @current = node
          break if position.equal?(node)
        end
      elsif index < 0
        while index < 0 and node and node.prev
          node = node.prev
          index += 1
          @current = node
          break if position.equal?(node)
        end
      end
      current
    end

    #
    # Modifications
    #
    # return new size
    def insert(value)
      node = @current
      @current = LinkNode.call(value, node, :circle_after, self,  &@match_value)
      if self.size == 0           # only
        self.head      =  @current
        self.tail      =  @current
      elsif self.tail == node
        self.tail      =  @current
        @current.next      = self.head
        self.head.prev = @current
      end
      self.size += 1
    end
    alias_method  :append, :insert

    # return new size
    def insert_before(position_value, value)
      target = find_by_value(position_value)
      node = LinkNode.call(value, target, :circle_before, self,  &@match_value)
      @current = node
      if self.size == 0           # only
        self.head =  node
        self.tail =  node
      elsif self.head == target   # new head
        self.head      =  node
        node.prev      = self.tail
        self.tail.next = node
      end
      self.size += 1
    end

    # return new size
    def insert_after(position_value, value)
      target = find_by_value(position_value)
      node = LinkNode.call(value, target, :circle_after, self,  &@match_value)
      @current = node
      if self.size == 0           # only
        self.head =  node
        self.tail =  node
      elsif self.tail == target
        self.tail =  node
        node.next      = self.head
        self.head.prev = node
      end
      self.size += 1
    end

    # return remaining size
    def remove(value)
      target_node = find_by_value(value)
      if target_node
        if self.size == 1                           # will become zero
          @current = nil
          self.head = nil
          self.tail = nil
        elsif target_node.equal?(self.head)            # top
          @current = target_node.next
          @current.prev = target_node.prev
          self.tail.next = @current
          self.head = @current
        elsif target_node.equal?(self.tail)            # bottom
          @current = target_node.prev
          @current.next = target_node.next
          self.head.prev = @current
          self.tail = @current
        else                                   # middle
          @current           = target_node.prev
          @current.next      = target_node.next
          @current.next.prev = @current
        end
        target_node.remove!
        self.size -= 1
      end
    end

  protected

    def find_by_index(index)
      return nil if ( index > self.size || index < 1 )
      node = self.head
      node = node.next while ( (index -= 1) > 0 )
      @current = node
      node
    end

  end # end class
end # module
