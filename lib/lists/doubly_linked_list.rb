##
# File <root>/lib/lists/doubly_linked_list.rb
#
#     ll = Lists::DoublyLinkedList.new(*vargs, &compare_key_proc)
# - or -
#     ll = Lists::DoublyLinkedList.new(1,2,3,4,5) {|element| element[:key] }
# - or -
#     ll = Lists::DoublyLinkedList.new(
#                     {key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}
#          ) {|el| el[:key] }
# - or -
#     cmp_proc = lambda { |el| el[:key] }
#     vargs = [{key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}]
#     ll = Lists::DoublyLinkedList.new(*vargs, &cmp_proc)
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
  # Doubly Linked List
  # Forward (#next) and Backwards (#prev) navigation
  # Head when (prev == nil)
  # Tail when (next == nil)

  # LinkedCommons provides;
  # - #initialize, #first, #next, #current, #last, #at_index,
  #   #insert, #prepend, #append, #empty?, #clear,
  #   #each, #to_a, and #sort!
  #
  class DoublyLinkedList < LinkedCommons

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
      if index > 0
        while index > 1 and node and node.next
          node = node.next
          index -= 1
        end
        @current = node
      elsif index < 0
        while index < 0 and node and node.prev
          node = node.prev
          index += 1
        end
        @current = node
      end
      current
    end

    #
    # Modifications
    #

    # return new size
    def insert(value)
      node = @current
      @current = LinkNode.call(value, node, :after, self,  &@match_value)
      self.head = @current if self.head.nil?
      self.tail = @current if self.tail.equal?(node)
      self.size += 1
    end
    alias_method  :append, :insert

    # return new size
    def insert_before(position_value, value)
      target = find_by_value(position_value)
      node = LinkNode.call(value, target, :before, self,  &@match_value)
      @current = node if target
      self.head = node if self.head.equal?(target)
      self.tail = node if self.tail.nil?
      self.size += 1
    end

    # return new size
    def insert_after(position_value, value)
      target = find_by_value(position_value)
      node = LinkNode.call(value, target, :after, self,  &@match_value)
      @current = node
      self.head = node if self.head.nil?
      self.tail = node if self.tail.equal?(target)
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
        elsif target_node.prev.nil?            # top
          @current = target_node.next
          @current.prev = nil
          self.head = @current
        elsif target_node.next.nil?            # bottom
          @current = target_node.prev
          @current.next = nil
          self.tail = @current
        else                                   # middle
          @current = target_node.prev
          @current.next = target_node.next
          target_node.next.prev = @current
        end
        target_node.remove!
        self.size -= 1
      end
    end

  protected

    def find_by_index(index)
      return nil if self.head.nil? or index < 1 or index > self.size
      node = self.head
      node = node.next while ((index -= 1) > 0 and node.next)
      @current = node if node
      node
    end

  end # end class
end # module
