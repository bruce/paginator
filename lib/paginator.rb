module Paginator

  class ArgumentError < ::ArgumentError; end
  class MissingCountError < ArgumentError; end
  class MissingSelectError < ArgumentError; end

  autoload :Pager, 'paginator/pager'
  autoload :Page,  'paginator/page'

  def self.create(count, per_page, &select)
    Pager.new(count, per_page, &select)
  end

end
