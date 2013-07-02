module Paginator

  # Page object
  #
  # Retrieves items for a page and provides metadata about the position
  # of the page in the paginator
  class Page

    include Enumerable

    attr_reader :number, :pager

    def initialize(pager, number, select) #:nodoc:
      @pager, @number = pager, number
      @offset = (number - 1) * pager.per_page
      @select = select
    end

    # Retrieve the items for this page
    # * Caches
    def items
      @items ||= @select.call
    end

    # Does this page have any items?
    def empty?
      items.empty?
    end

    # Checks to see if there's a page before this one
    def prev?
      @number > 1
    end

    # Get previous page (if possible)
    def prev
      @pager.page(@number - 1) if prev?
    end

    # Checks to see if there's a page after this one
    def next?
      @number < @pager.number_of_pages
    end

    # Get next page (if possible)
    def next
      @pager.page(@number + 1) if next?
    end

    # The "item number" of the first item on this page
    def first_item_number
      1 + @offset
    end

    # The "item number" of the last item on this page
    def last_item_number
      if next?
        @offset + @pager.per_page
      else
        @pager.count
      end
    end

    def ==(other) #:nodoc:
      @pager == other.pager && self.number == other.number
    end

    def each(&block)
      items.each(&block)
    end

    def method_missing(meth, *args, &block) #:nodoc:
      if @pager.respond_to?(meth)
        @pager.__send__(meth, *args, &block)
      else
        super
      end
    end

  end

end
