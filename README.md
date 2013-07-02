Paginator
=========

Paginator is a simple pagination class that provides a generic interface suitable
for use in any Ruby program.

Paginator doesn't make any assumptions as to how data is retrieved; you just
have to provide it with the total number of objects and a way to pull a specific
set of objects based on the offset and number of objects per page.

Examples
--------

In both of these examples I'm using a `PER_PAGE` constant (the number of
items per page), but it's merely for labeling purposes.

You could, of course, just pass in the number of items per page
directly to the initializer without assigning it somewhere beforehand.

### In Plain Ruby

```ruby
bunch_o_data = (1..60).to_a
pager = Paginator.create(bunch_o_data.size, PER_PAGE) do |offset, per_page|
  bunch_o_data[offset,per_page]
end
pager.each do |page|
  puts "Page ##{page.number}"
  page.each do |item|
    puts item
  end
end
```

### In Rails

Nothing changes with Paginator; you just use ActiveRecord from within
the block you provide.

A controller action:

```ruby
def index
  @pager = Paginator.create(Foo.count, PER_PAGE) do |offset, per_page|
    Foo.limit(per_page).offset(offset)
  end
  @page = @pager.page(params[:page])
end
```

In your view:

```erb
<% @page.each do |foo| %>
  <%# Show something for each item %>
<% end %>
<%= @page.number %>
<%= link_to("Prev", foos_url(page: @page.prev.number)) if @page.prev? %>
<%= link_to("Next", foos_url(page: @page.next.number)) if @page.next? %>
```

### License

See `LICENSE.txt`.
