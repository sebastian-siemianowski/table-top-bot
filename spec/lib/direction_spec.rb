# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Direction do
  subject(:direction) { described_class.new }

  describe '#directions' do
    it 'returns valid directions' do
      expect(direction.directions).to eq %w[NORTH EAST SOUTH WEST]
    end
  end

  describe '#turn_left' do
    it 'turns left from NORTH to WEST' do
      expect(direction.turn_left('NORTH')).to eq('WEST')
    end

    it 'turns left from WEST to SOUTH' do
      expect(direction.turn_left('WEST')).to eq('SOUTH')
    end

    it 'turns left from SOUTH to EAST' do
      expect(direction.turn_left('SOUTH')).to eq('EAST')
    end

    it 'turns left from EAST to NORTH' do
      expect(direction.turn_left('EAST')).to eq('NORTH')
    end
  end

  describe '#turn_right' do
    it 'turns right from NORTH to EAST' do
      expect(direction.turn_right('NORTH')).to eq('EAST')
    end

    it 'turns right from EAST to SOUTH' do
      expect(direction.turn_right('EAST')).to eq('SOUTH')
    end

    it 'turns right from SOUTH to WEST' do
      expect(direction.turn_right('SOUTH')).to eq('WEST')
    end

    it 'turns right from WEST to NORTH' do
      expect(direction.turn_right('WEST')).to eq('NORTH')
    end
  end

  describe '#valid?' do
    it 'returns true for NORTH' do
      expect(direction.valid?('NORTH')).to be true
    end

    it 'returns true for EAST' do
      expect(direction.valid?('EAST')).to be true
    end

    it 'returns true for SOUTH' do
      expect(direction.valid?('SOUTH')).to be true
    end

    it 'returns true for WEST' do
      expect(direction.valid?('WEST')).to be true
    end

    it 'returns false for UP' do
      expect(direction.valid?('UP')).to be false
    end

    it 'returns false for DOWN' do
      expect(direction.valid?('DOWN')).to be false
    end

    it 'returns false for empty string' do
      expect(direction.valid?('')).to be false
    end

    it 'returns false for nil' do
      expect(direction.valid?(nil)).to be false
    end
  end
end
