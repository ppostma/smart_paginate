# frozen_string_literal: true

module SmartPaginate
  class Paginate
    attr_reader :current_page, :per_page

    def initialize(current_page, per_page = nil)
      @current_page = convert(current_page, 1)
      @per_page = convert(per_page, 20)
    end

    def offset
      (current_page - 1) * per_page
    end

    private

    def convert(value, default_value)
      value = value.to_i
      value > 0 ? value : default_value
    end
  end
end
