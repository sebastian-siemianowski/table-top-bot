# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Robot do
  subject(:robot) { described_class.new }

  describe '#hello' do
    it 'returns Hello World' do
      expect(robot.hello).to eq 'Hello World'
    end
  end
end
