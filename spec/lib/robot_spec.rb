# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Robot do
  subject(:robot) { described_class.new }

  describe '#table' do
    it 'returns instance of table' do
      expect(robot.table).to be_instance_of(TableTopBot::Table)
    end
  end
end
