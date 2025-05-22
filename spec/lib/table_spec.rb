# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Table do
  subject(:table) { described_class.new }

  describe '#width' do
    it 'returns correct width' do
      expect(table.width).to eq 5
    end
  end

  describe '#height' do
    it 'returns correct height' do
      expect(table.height).to eq 5
    end
  end

  describe '#valid_position?' do
    it 'returns true for valid position' do
      expect(table.valid_position?(width: 0, height: 0)).to eq true
    end

    it 'returns false for invalid position' do
      expect(table.valid_position?(width: 5, height: 0)).to eq false
    end

    it 'returns false if width is not integer' do
      expect(table.valid_position?(width: nil, height: 0)).to eq false
    end

    it 'returns false if height is not integer' do
      expect(table.valid_position?(width: 0, height: nil)).to eq false
    end
  end
end
