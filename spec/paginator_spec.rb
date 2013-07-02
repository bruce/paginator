require 'minitest/autorun'
require 'minitest/spec'
require 'paginator'

PER_PAGE = 10

describe Paginator do

  before do
    @data = (0..43).to_a
    @pager = Paginator.create(@data.size, PER_PAGE) do |offset, per_page|
      @data[offset, per_page]
    end
  end

  it "needs a block" do
    assert_raises(Paginator::MissingSelectError) do
      @pager = Paginator.create(@data.size, PER_PAGE)
    end
  end

  it "can get the last page" do
    assert_equal @pager.last, @pager.page(5)
  end

  it "can get the first page" do
    assert_equal @pager.first, @pager.page(1)
  end

  it "does not exceed per_page" do
    @pager.each do |page|
      assert page.items.size <= PER_PAGE
    end
  end

  it "only has less items on the last page" do
    @pager.each do |page|
      if page != @pager.last
        assert page.items.size <= PER_PAGE
      else
        assert page.items.size < PER_PAGE
      end
    end
  end

  it "returns the correct first page" do
    assert_equal @pager.page(1).number, @pager.first.number
  end


  it "returns the correct last page" do
    assert_equal @pager.page(5).number, @pager.last.number
  end

  it "has no next page when on the last page" do
    assert !@pager.last.next?
    assert !@pager.last.next
  end

  it "has no previous page on the first page" do
    assert !@pager.first.prev?
    assert !@pager.first.prev
  end

  it "is enumerable" do
    @pager.each do |page|
      assert page
      page.each do |item|
        assert item
      end
      page.each_with_index do |item, index|
        assert_equal page.items[index], item
      end
      assert_equal page.items, page.inject([]) {|list, item| list << item }
    end
  end

  it "supports each.with_index" do
    page_offset = 0
    @pager.each.with_index do |page, page_index|
      assert page
      assert_equal page_offset, page_index
      item_offset = 0
      page.each.with_index do |item, item_index|
        assert item
        assert_equal item_offset, item_index
        item_offset += 1
      end
      page_offset += 1
    end
  end

  it "has the correct number of pages" do
    assert_equal 5, @pager.number_of_pages
  end

  it "yields per_page for a block with an arity of 2" do
    pager = Paginator.create(20, 2) do |offset, per_page|
      assert_equal 2, per_page
    end
    pager.page(1).items
  end

  it "does not yield per_page for a block of arity 1" do
    pager = Paginator.create(20, 2) do |offset|
      assert_equal 0, offset
    end
    pager.page(1).items
  end

  it "has pages that know the first and last page numbers" do
    items = (1..11).to_a
    pager = Paginator.create(items.size,3) do |offset, per_page|
      items[offset, per_page]
    end
    page = pager.page(1)
    assert_equal 1, page.first_item_number
    assert_equal 3, page.last_item_number
    page = pager.page(2)
    assert_equal 4, page.first_item_number
    assert_equal 6, page.last_item_number
    page = pager.page(3)
    assert_equal 7, page.first_item_number
    assert_equal 9, page.last_item_number
    page = pager.page(4)
    assert_equal 10, page.first_item_number
    assert_equal 11, page.last_item_number
  end

end
