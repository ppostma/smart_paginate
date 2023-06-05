# frozen_string_literal: true

require 'spec_helper'

describe SmartPaginate::Paginate do
  describe '#current_page' do
    it 'accepts nil as current_page and converts it to 1' do
      page = described_class.new(nil, 10)
      expect(page.current_page).to eq(1)
    end

    it 'accepts 0 as current_page and converts it to 1' do
      page = described_class.new(0, 10)
      expect(page.current_page).to eq(1)
    end

    it 'accepts a string as current_page and converts it to an integer' do
      page = described_class.new("2", 10)
      expect(page.current_page).to eq(2)
    end

    it 'accepts an invalid string as current_page and converts it to 1' do
      page = described_class.new("foobar", 10)
      expect(page.current_page).to eq(1)
    end

    it 'accepts any integer as current_page and returns it' do
      page = described_class.new(5, 10)
      expect(page.current_page).to eq(5)
    end
  end

  describe '#per_page' do
    it 'accepts nil as per_page and converts it to 20' do
      page = described_class.new(1, nil)
      expect(page.per_page).to eq(20)
    end

    it 'accepts 0 as per_page and converts it to 20' do
      page = described_class.new(1, 0)
      expect(page.per_page).to eq(20)
    end

    it 'accepts a string as per_page and converts it to an integer' do
      page = described_class.new(1, "2")
      expect(page.per_page).to eq(2)
    end

    it 'accepts an invalid string as per_page and converts it to 20' do
      page = described_class.new(1, "foobar")
      expect(page.per_page).to eq(20)
    end

    it 'accepts any integer as per_page and returns it' do
      page = described_class.new(1, 5)
      expect(page.per_page).to eq(5)
    end
  end

  describe '#offset' do
    it 'returns 0 when current_page is 1 and per_page is 10' do
      page = described_class.new(1, 10)
      expect(page.offset).to eq(0)
    end

    it 'returns 10 when current_page is 1 and per_page is 10' do
      page = described_class.new(2, 10)
      expect(page.offset).to eq(10)
    end

    it 'returns 100 when current_page is 10 and per_page is 10' do
      page = described_class.new(10, 10)
      expect(page.offset).to eq(90)
    end

    it 'returns 20 when current_page is 5 and per_page is 5' do
      page = described_class.new(5, 5)
      expect(page.offset).to eq(20)
    end
  end
end
