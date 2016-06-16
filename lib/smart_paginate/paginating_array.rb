require "smart_paginate/paginate"

module SmartPaginate
  class PaginatingArray < Array
    attr_accessor :current_page, :per_page, :total_entries

    def paginate(options = {})
      page = SmartPaginate::Paginate.new(options.fetch(:page), options[:per_page])

      array = self.slice(page.offset, page.per_page)
      array.current_page = page.current_page
      array.per_page = page.per_page
      array.total_entries = length
      array
    end

    def next_page?
      (current_page * per_page) < total_entries
    end

    def previous_page?
      current_page > 1
    end

    def next_page
      current_page + 1 if next_page?
    end

    def previous_page
      current_page - 1 if previous_page?
    end

    def total_pages
      (total_entries / per_page.to_f).ceil
    end
  end
end
