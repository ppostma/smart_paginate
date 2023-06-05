# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SmartPaginate::PaginatingArray do
  subject(:array) { described_class.new(%w[1 2 3 4 5 6 7 8 9 10]) }

  describe '#paginate' do
    it 'raises an exception when page option is absent' do
      expect { array.paginate(per_page: 1) }.to raise_error(KeyError)
    end

    it 'sets per_page to 20 when the per_page option is absent' do
      users = array.paginate(page: 1)
      expect(users.per_page).to eq(20)
    end

    it 'returns the first page when asked for' do
      users = array.paginate(per_page: 1, page: 1)
      expect(users.length).to eq(1)
      expect(users.first).to eq('1')
    end

    it 'returns the second page when asked for' do
      users = array.paginate(per_page: 1, page: 2)
      expect(users.length).to eq(1)
      expect(users.first).to eq('2')
    end

    it 'returns the last page when asked for' do
      users = array.paginate(per_page: 1, page: 10)
      expect(users.length).to eq(1)
      expect(users.first).to eq('10')
    end

    it 'returns nil after the last page' do
      users = array.paginate(per_page: 1, page: 20)
      expect(users.length).to eq(0)
      expect(users.first).to be nil
    end

    it 'does not modify the original array when paginating' do
      users = array.clone
      users.paginate(per_page: 1, page: 1)
      users.paginate(per_page: 1, page: 2)
      expect(users).to eq(array)
    end
  end

  describe '#empty?' do
    it 'returns false when results are present' do
      users = array.paginate(per_page: 1, page: 1)
      expect(users.empty?).to be false
    end

    it 'returns true when no results are present' do
      users = array.paginate(per_page: 1, page: 11)
      expect(users.empty?).to be true
    end
  end

  describe '#total_entries' do
    it 'returns the total number of entries on the first page' do
      users = array.paginate(per_page: 1, page: 1)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries on the second page' do
      users = array.paginate(per_page: 1, page: 2)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries on the last page' do
      users = array.paginate(per_page: 1, page: 10)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries after the last page' do
      users = array.paginate(per_page: 1, page: 11)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries far after the last page' do
      users = array.paginate(per_page: 1, page: 20)
      expect(users.total_entries).to eq(10)
    end
  end

  describe '#total_pages' do
    it 'returns the total number of pages when per_page is 1' do
      users = array.paginate(per_page: 1, page: 1)
      expect(users.total_pages).to eq(10)
    end

    it 'returns the total number of pages when per_page is 3' do
      users = array.paginate(per_page: 3, page: 1)
      expect(users.total_pages).to eq(4)
    end

    it 'returns the total number of pages when per_page is 9' do
      users = array.paginate(per_page: 9, page: 1)
      expect(users.total_pages).to eq(2)
    end

    it 'returns the total number of pages when per_page is more than number of records' do
      users = array.paginate(per_page: 11, page: 1)
      expect(users.total_pages).to eq(1)
    end

    it 'returns the total number of pages after the last page' do
      users = array.paginate(per_page: 1, page: 11)
      expect(users.total_pages).to eq(10)
    end

    it 'returns the total number of pages far after the last page' do
      users = array.paginate(per_page: 1, page: 20)
      expect(users.total_pages).to eq(10)
    end
  end

  describe '#previous_page' do
    it 'returns the previous page when present' do
      users = array.paginate(per_page: 1, page: 10)
      expect(users.previous_page).to eq(9)
    end

    it 'returns the first page when present' do
      users = array.paginate(per_page: 1, page: 2)
      expect(users.previous_page).to eq(1)
    end

    it 'returns nil when no pages are present' do
      users = array.paginate(per_page: 1, page: 1)
      expect(users.previous_page).to be nil
    end
  end

  describe '#next_page' do
    it 'returns the next page when present' do
      users = array.paginate(per_page: 1, page: 1)
      expect(users.next_page).to eq(2)
    end

    it 'returns the last page when present' do
      users = array.paginate(per_page: 1, page: 9)
      expect(users.next_page).to eq(10)
    end

    it 'returns nil when no pages are present' do
      users = array.paginate(per_page: 1, page: 10)
      expect(users.next_page).to be nil
    end
  end
end
