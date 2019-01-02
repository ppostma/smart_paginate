require 'spec_helper'

describe SmartPaginate::ActiveRecordExtension do
  class User < ActiveRecord::Base
    include SmartPaginate

    scope :nothing, -> { where("1 = 0") }
  end

  before(:all) do
    ActiveRecord::Base.connection_pool.with_connection do |conn|
      conn.create_table :users do |t|
        t.string :name
      end
    end

    10.times { |i| User.create!(name: "test_#{i}") }
  end

  after(:all) do
    User.delete_all

    ActiveRecord::Base.connection_pool.with_connection do |conn|
      conn.drop_table :users
    end
  end

  describe '#paginate' do
    it 'raises an exception when page option is absent' do
      expect { User.paginate(per_page: 1) }.to raise_error(KeyError)
    end

    it 'sets per_page to 20 when the per_page option is absent' do
      users = User.paginate(page: 1)
      expect(users.per_page).to eq(20)
    end

    it 'returns the first page when asked for' do
      users = User.order(:name).paginate(per_page: 1, page: 1)
      expect(users.length).to eq(1)
      expect(users.first.name).to eq("test_0")
    end

    it 'returns the second page when asked for' do
      users = User.order(:name).paginate(per_page: 1, page: 2)
      expect(users.length).to eq(1)
      expect(users.first.name).to eq("test_1")
    end

    it 'returns the last page when asked for' do
      users = User.order(:name).paginate(per_page: 1, page: 5)
      expect(users.length).to eq(1)
      expect(users.first.name).to eq("test_4")
    end

    it 'returns nil after the last page' do
      users = User.order(:name).paginate(per_page: 1, page: 11)
      expect(users.length).to eq(0)
      expect(users.first).to be nil
    end
  end

  describe '#empty?' do
    it 'returns false when results are present' do
      users = User.paginate(per_page: 1, page: 1)
      expect(users.empty?).to be false
    end

    it 'returns true when no results are present' do
      users = User.paginate(per_page: 1, page: 11)
      expect(users.empty?).to be true
    end
  end

  describe '#count' do
    it 'returns the number of entries when per_page is 1 on the first page' do
      users = User.paginate(per_page: 1, page: 1)
      expect(users.count).to eq(1)
    end

    it 'returns the number of entries when per_page is 3 on the first page' do
      users = User.paginate(per_page: 3, page: 1)
      expect(users.count).to eq(3)
    end

    it 'returns the number of entries when per_page is 3 on the last page' do
      users = User.paginate(per_page: 3, page: 4)
      expect(users.count).to eq(1)
    end

    it 'returns the number of entries when per_page is 3 after the last page' do
      users = User.paginate(per_page: 3, page: 5)
      expect(users.count).to eq(0)
    end
  end

  describe '#total_entries' do
    it 'returns zero when there are no records' do
      users = User.nothing.paginate(per_page: 1, page: 1)
      expect(users.total_entries).to eq(0)
    end

    it 'returns the total number of entries on the first page' do
      users = User.paginate(per_page: 1, page: 1)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries on the second page' do
      users = User.paginate(per_page: 1, page: 2)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries on the last page' do
      users = User.paginate(per_page: 1, page: 10)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries after the last page' do
      users = User.paginate(per_page: 1, page: 11)
      expect(users.total_entries).to eq(10)
    end

    it 'returns the total number of entries far after the last page' do
      users = User.paginate(per_page: 1, page: 20)
      expect(users.total_entries).to eq(10)
    end
  end

  describe '#total_pages' do
    it 'returns zero when there are no records' do
      users = User.nothing.paginate(per_page: 1, page: 1)
      expect(users.total_pages).to eq(0)
    end

    it 'returns the total number of pages when per_page is 1' do
      users = User.paginate(per_page: 1, page: 1)
      expect(users.total_pages).to eq(10)
    end

    it 'returns the total number of pages when per_page is 3' do
      users = User.paginate(per_page: 3, page: 1)
      expect(users.total_pages).to eq(4)
    end

    it 'returns the total number of pages when per_page is 9' do
      users = User.paginate(per_page: 9, page: 1)
      expect(users.total_pages).to eq(2)
    end

    it 'returns the total number of pages when per_page is more than number of records' do
      users = User.paginate(per_page: 11, page: 1)
      expect(users.total_pages).to eq(1)
    end

    it 'returns the total number of pages after the last page' do
      users = User.paginate(per_page: 1, page: 11)
      expect(users.total_pages).to eq(10)
    end

    it 'returns the total number of pages far after the last page' do
      users = User.paginate(per_page: 1, page: 20)
      expect(users.total_pages).to eq(10)
    end
  end

  describe '#previous_page' do
    it 'returns the previous page when present' do
      users = User.paginate(per_page: 1, page: 10)
      expect(users.previous_page).to eq(9)
    end

    it 'returns the first page when present' do
      users = User.paginate(per_page: 1, page: 2)
      expect(users.previous_page).to eq(1)
    end

    it 'returns nil when no pages are present' do
      users = User.paginate(per_page: 1, page: 1)
      expect(users.previous_page).to be nil
    end
  end

  describe '#next_page' do
    it 'returns the next page when present' do
      users = User.paginate(per_page: 1, page: 1)
      expect(users.next_page).to eq(2)
    end

    it 'returns the last page when present' do
      users = User.paginate(per_page: 1, page: 9)
      expect(users.next_page).to eq(10)
    end

    it 'returns nil when no pages are present' do
      users = User.paginate(per_page: 1, page: 10)
      expect(users.next_page).to be nil
    end
  end
end
