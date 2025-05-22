# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Table do
  subject(:table) { described_class.new }

  describe '#width' do
    it 'returns correct width' do
      expect(table.width).to eq 5
    end

    it 'returns correct height' do
      expect(table.height).to eq 5
    end
  end
end
