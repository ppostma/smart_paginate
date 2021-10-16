# SmartPaginate

[![Gem Version](https://badge.fury.io/rb/smart_paginate.svg)](https://badge.fury.io/rb/smart_paginate)
[![Build Status](https://github.com/ppostma/smart_paginate/actions/workflows/test.yml/badge.svg)](https://github.com/ppostma/smart_paginate/actions)
[![Code Climate](https://codeclimate.com/github/ppostma/smart_paginate/badges/gpa.svg)](https://codeclimate.com/github/ppostma/smart_paginate)

Simple, smart and clean pagination extension for Active Record and plain Ruby Arrays:

- **Simple:** Easy to use, with a simple interface. It just does pagination, nothing more.
- **Smart:** Can navigate through the pages without having to do an expensive count query. SmartPaginate will actually fetch one record more than needed and use it to determine if there's a next page.
- **Clean:** The code is as minimal as possible while still useful. SmartPaginate does not auto include itself or monkey patch any classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart_paginate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smart_paginate

## Usage

### Active Record

To enable pagination in an Active Record model, include the `SmartPaginate` concern in your class:

```ruby
class User < ActiveRecord::Base
  include SmartPaginate
end
```

Then you can use the `paginate` scope to paginate results:

```ruby
users = User.order(:name).paginate(page: 1, per_page: 20)
```

After using `paginate`, the following methods will be available to query the next page, number of pages, etc:

```ruby
users.next_page?      # true when a next page exists
users.next_page       # returns next page number
users.previous_page?  # true when a previous page exists
users.previous_page   # returns previous page number
users.total_entries   # returns total number of entries (!)
users.total_pages     # returns total number of pages (!)
```

**(!) Please note** that the `total_entries` and `total_pages` methods will do a `SELECT COUNT(*)` query to retrieve the total number of entries. This can be very expensive on a table with many records!

### Array

For paginating Arrays, use the class `SmartPaginate::PaginatingArray` to convert a plain Array to a paginatable Array:

```ruby
array = (1..100).to_a
array = SmartPaginate::PaginatingArray(array)
array.paginate(page: 1, per_page: 20)
```

### Helpers

Because SmartPaginate was designed to be as simple and clean as possible, it does not provide any helpers to create pagination links in your views. It is however very easy to write your own, e.g. for Rails:

```ruby
module PaginateHelper
  def paginate(collection, options = {})
    content_tag(:div, class: "pagination") do
      if collection.present?
        concat link_to("Previous", url_for(options.merge(per_page: collection.per_page, page: collection.previous_page)), class: "previous_page") if collection.previous_page?
        concat link_to("Next", url_for(options.merge(per_page: collection.per_page, page: collection.next_page)), class: "next_page") if collection.next_page?
      end
    end
  end
end
```

Which you can then use in the view like this:

```ruby
<%= paginate(@objects, params.permit) %>
```

Make sure you whitelist the allowed parameters!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ppostma/smart_paginate.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

