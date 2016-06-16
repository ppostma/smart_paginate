require "smart_paginate/active_record"
require "smart_paginate/paginating_array"
require "smart_paginate/version"
require "active_support/concern"

module SmartPaginate
  extend ActiveSupport::Concern

  include SmartPaginate::ActiveRecord
end
