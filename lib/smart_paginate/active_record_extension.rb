# frozen_string_literal: true

require 'smart_paginate/paginate'
require 'active_support/concern'
require 'active_record'

module SmartPaginate
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    module ClassMethods
      def paginate(options = {})
        page = SmartPaginate::Paginate.new(options.fetch(:page), options[:per_page])

        rel = all.extending(RelationMethods)
        # add one more to the limit so we can quickly determine if there are more pages present
        rel = rel.limit(page.per_page + 1).offset(page.offset)
        rel.current_page = page.current_page
        rel.per_page = page.per_page
        rel
      end
    end

    module RelationMethods
      attr_accessor :current_page, :per_page

      # Override #count: make it return the number of entries that we expect
      def count(*args)
        if limit_value && per_page && limit_value > per_page
          rel = except(:limit).limit(per_page)
          rel.count(*args)
        else
          super(*args)
        end
      end

      # Override #empty: check fetched records instead of counting
      def empty?
        load # make sure we have determined the number of fetched records

        @number_of_records.zero?
      end

      # Override #load: fetch/slice records and determine number of records
      def load
        super
        slice_records!

        self
      end

      def next_page?
        load # make sure we have determined the number of fetched records

        @number_of_records > per_page # there's a next page when we've fetched more records than per_page
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
        total_entries.positive? ? (total_entries / per_page.to_f).ceil : 1
      end

      def total_entries
        @total_entries ||= begin
          load # make sure we have determined the number of fetched records

          # if we know that there are no more records, then we can calculate total_entries
          if (current_page == 1 || @number_of_records.positive?) && @number_of_records <= per_page
            offset_value + @number_of_records
          else
            rel = except(:limit, :offset)
            rel.count(:all)
          end
        end
      end

      private

      # remember total number of fetched records and slice records to per_page
      def slice_records!
        @number_of_records ||= @records.length

        @records = @records.slice(0, per_page) if @number_of_records > per_page
      end
    end
  end
end
