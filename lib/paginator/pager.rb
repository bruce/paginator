module Paginator

  class Pager
    include Enumerable

    attr_reader :per_page, :count

    # Instantiate a new Paginator object
    #
    # Provide:
    # * A total count of the number of objects to paginate
    # * The number of objects in each page
    # * A block that returns the array of items
    #   * The block is passed the item offset
    #     (and the number of items to show per page, for
    #     convenience, if the arity is 2)
    def initialize(count, per_page, &select)
      @count, @per_page = count, per_page
      unless select
        raise MissingSelectError, "Must provide block to select data for each page"
      end
      @select = select
    end

    # Total number of pages
    def number_of_pages
      (@count / @per_page).to_i + (@count % @per_page > 0 ? 1 : 0)
    end

    # First page object
    def first
      page 1
    end

    # Last page object
    def last
      page number_of_pages
    end

    def each
      1.upto(number_of_pages) do |number|
        yield page(number)
      end
    end

    # Retrieve page object by number
    def page(number)
      number = (n = number.to_i) > 0 ? n : 1
      Page.new(self, number, lambda {
                 offset = (number - 1) * @per_page
                 args = [offset]
                 args << @per_page if @select.arity == 2
                 @select.call(*args)
               })
    end
  end

end
