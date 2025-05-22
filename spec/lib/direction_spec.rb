# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Direction do
  subject(:direction) { described_class.new }

  describe '#directions' do
    it 'returns valid Directions' do
      expect(direction.directions).to eq %w[NORTH EAST SOUTH WEST]
    end
  end

  describe '.valid?' do
    it 'returns true for NORTH' do
      expect(described_class.valid?('NORTH')).to be true
    end

    it 'returns true for EAST' do
      expect(described_class.valid?('EAST')).to be true
    end

    it 'returns true for SOUTH' do
      expect(described_class.valid?('SOUTH')).to be true
    end

    it 'returns true for WEST' do
      expect(described_class.valid?('WEST')).to be true
    end

    it 'returns false for UP' do
      expect(described_class.valid?('UP')).to be false
    end

    it 'returns false for DOWN' do
      expect(described_class.valid?('DOWN')).to be false
    end

    it 'returns false for empty string' do
      expect(described_class.valid?('')).to be false
    end

    it 'returns false for nil' do
      expect(described_class.valid?(nil)).to be false
    end
  end
end
