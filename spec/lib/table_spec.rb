# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Table do
  subject(:table) { described_class.new }

  describe '#initialize' do
    it 'sets default width to 5' do
      expect(table.width).to eq 5
    end

    it 'sets default height to 5' do
      expect(table.height).to eq 5
    end
  end

  describe '#valid_position?' do
    context 'with valid coordinates' do
      it 'returns true for (0,0)' do
        expect(table.valid_position?(x_coordinate: 0, y_coordinate: 0)).to be true
      end

      it 'returns true for (4,4)' do
        expect(table.valid_position?(x_coordinate: 4, y_coordinate: 4)).to be true
      end

      it 'returns true for (2,3)' do
        expect(table.valid_position?(x_coordinate: 2, y_coordinate: 3)).to be true
      end
    end

    context 'with invalid coordinates (out of bounds)' do
      it 'returns false for (-1,0)' do
        expect(table.valid_position?(x_coordinate: -1, y_coordinate: 0)).to be false
      end

      it 'returns false for (0,-1)' do
        expect(table.valid_position?(x_coordinate: 0, y_coordinate: -1)).to be false
      end

      it 'returns false for (5,0)' do
        expect(table.valid_position?(x_coordinate: 5, y_coordinate: 0)).to be false
      end

      it 'returns false for (0,5)' do
        expect(table.valid_position?(x_coordinate: 0, y_coordinate: 5)).to be false
      end

      it 'returns false for (5,5)' do
        expect(table.valid_position?(x_coordinate: 5, y_coordinate: 5)).to be false
      end
    end

    context 'with non-integer coordinates' do
      it 'returns false for ("a",0)' do
        expect(table.valid_position?(x_coordinate: 'a', y_coordinate: 0)).to be false
      end

      it 'returns false for (0,"b")' do
        expect(table.valid_position?(x_coordinate: 0, y_coordinate: 'b')).to be false
      end

      it 'returns false for (nil,0)' do
        expect(table.valid_position?(x_coordinate: nil, y_coordinate: 0)).to be false
      end

      it 'returns false for (0,nil)' do
        expect(table.valid_position?(x_coordinate: 0, y_coordinate: nil)).to be false
      end

      it 'returns false for (1.5, 0)' do
        expect(table.valid_position?(x_coordinate: 1.5, y_coordinate: 0)).to be false
      end

      it 'returns false for (0, 2.5)' do
        expect(table.valid_position?(x_coordinate: 0, y_coordinate: 2.5)).to be false
      end
    end
  end
end
