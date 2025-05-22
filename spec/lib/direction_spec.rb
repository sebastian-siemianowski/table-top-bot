# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Direction do
  subject(:direction) { described_class.new }

  describe 'DIRECTIONS' do
    it 'returns valid Directions' do
      expect(described_class::DIRECTIONS).to eq %w[NORTH EAST SOUTH WEST]
    end
  end
end