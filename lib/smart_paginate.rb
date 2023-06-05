# frozen_string_literal: true

require 'smart_paginate/active_record_extension'
require 'smart_paginate/paginating_array'
require 'smart_paginate/version'
require 'active_support/concern'

module SmartPaginate
  extend ActiveSupport::Concern

  include SmartPaginate::ActiveRecordExtension
end
