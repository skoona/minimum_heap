##
# Node.
# - primary object and container of value
##


module Lists

  class LinkNode

    attr_accessor :prev, :next, :value

    def self.call(val, anchor_node=nil, strategy=:after, mgr=nil, &cmp_key)
      self.new(val, anchor_node, strategy, mgr, &cmp_key)
    end

    def initialize(val, anchor_node=nil, strategy=:after, mgr=nil, &cmp_key)
      @value = val
      @prev = nil
      @next = nil
      @provider = mgr
      @cmp_proc = block_given? ? cmp_key : lambda {|a| a }

      case strategy
        when :single # after logic
          if anchor_node
            @next = anchor_node.next
            anchor_node.next = self
          end
        when :before
          @prev = anchor_node.prev if anchor_node
          anchor_node.prev = self if anchor_node
          @next = anchor_node
        when :after
          @next = anchor_node.next if anchor_node
          anchor_node.next = self if anchor_node
          @prev = anchor_node
        when :circle_before
          @prev = anchor_node ? anchor_node.prev : self
          anchor_node.prev = self if anchor_node
          @next = anchor_node ? anchor_node : self
        when :circle_after
          @next = anchor_node ? anchor_node.next : self
          anchor_node.next = self if anchor_node
          @prev = anchor_node ? anchor_node : self
      end
    end

    def match_by_value(other_value)
      @cmp_proc.call(self.value) == @cmp_proc.call(other_value)
    end

    # returns next node
    def remove!
      next_node = @next
      @value = nil
      @prev = nil
      @next = nil
      @provider = nil
      @cmp_proc = nil
      next_node
    end

    def to_s
      "Node with value: #{@value}"
    end

    # Reverse API to Parent Linked List Class
    def node_value
      node_value_request(:current)
    end
    def first_node
      node_request(:first)
    end
    def next_node
      node_request(:next)
    end
    def current_node
      node_request(:current)
    end
    def prev_node
      node_request(:prev)
    end
    def last_node
      node_request(:last)
    end

    # Retrieves requested node, not value
    def node_request(method_sym=:current, *vargs, &block)
      block_given? ? @provider.send(method_sym, *vargs, &block) :
          (vargs.size == 0 ?  @provider.send(method_sym) : @provider.send(method_sym, *vargs))
      @provider.instance_variable_get(:@current)
    end

    # Retrieves requested value, not node
    def node_value_request(method_sym=:current, *vargs, &block)
      block_given? ? @provider.send(method_sym, *vargs, &block) :
          (vargs.size == 0 ?  @provider.send(method_sym) : @provider.send(method_sym, *vargs))
    end

  end
end # module
