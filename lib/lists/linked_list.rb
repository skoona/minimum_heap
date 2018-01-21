##
# File <root>/lib/lists/linked_list.rb
#
#     ll = Lists::LinkedList.new(*vargs, &compare_key_proc)
# - or -
#     ll = Lists::LinkedList.new(1,2,3,4,5) {|element| element[:key] }
# - or -
#     ll = Lists::LinkedList.new(
#                     {key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}
#            ) {|el| el[:key] }
# - or -
#     cmp_proc = lambda { |el| el[:key] }
#     vargs = [{key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}]
#     ll = Lists::LinkedList.new(*vargs, &cmp_proc)
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
  # Singly Linked List
  # Forward or #next navigation only
  # Head is absolute via #first
  # Tail when (next == nil)

  # LinkedCommons provides;
  # - #initialize, #first, #next, #current, #last, #at_index,
  #   #insert, #prepend, #append, #empty?, #clear,
  #   #each, #to_a, and #sort!
  #
  class LinkedList < LinkedCommons

    #
    # Navigation
    #

    # +int position from current node
    def nth(index)
      node = @current
      while index > 1 and node and node.next
        node = node.next
        index -= 1
        @current = node
      end
      # no reverse or prev for Single List
      current
    end

    #
    # Modifications
    #

    def insert(value)
      node = @current
      @current = LinkNode.call(value, node, :single, self,  &@match_value)
      self.head = @current if self.head.nil?
      self.tail = @current if self.tail.equal?(node)
      self.size += 1
    end
    alias_method  :append, :insert

    # return new size
    def insert_before(position_value, value)
      prior, target = find_by_value(position_value)
      node = LinkNode.call(value, prior, :single, self,  &@match_value)
      node.next = target if target
      self.head = node if self.head.equal?(target)
      self.tail = node if self.tail.nil?
      @current = node
      self.size += 1
    end

    # return new size
    def insert_after(position_value, value)
      prior, target = find_by_value(position_value)
      node = LinkNode.call(value, target, :single, self,  &@match_value)
      self.head = node if self.head.nil?
      self.tail = node if self.tail.equal?(target)
      @current = node
      self.size += 1
    end

    # return remaining size
    def remove(value)
      prior, target_node = find_by_value(value)
      @current = prior.nil? ? target_node.next : prior
      @current.next = target_node.remove! if @current && target_node
      self.tail = @current.next if @current && self.tail.equal?(target_node)
      self.head = @current.next if @current && self.head.equal?(target_node)
      self.size -= 1
    end

  protected

    def find_by_value(value)
      return [@current, nil] if self.head.nil? || value.nil?
      prior  = self.head
      target = prior
      while target && !target.match_by_value(value)
        prior = target
        target = target.next
      end
      [prior, target]
    end

    def find_by_index(index)
      return nil if self.head.nil? || index < 1 || index > self.size
      node = self.head
      node = node.next while ((index -= 1) > 0 and node.next)
      @current = node if node
      node
    end

  end # end class
end # end module
