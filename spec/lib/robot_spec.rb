# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Robot do
  subject(:robot) { described_class.new }
  let(:table) { robot.table }

  describe '#table' do
    it 'returns instance of table' do
      expect(table).to be_instance_of(TableTopBot::Table)
    end
  end

  describe 'initial state' do
    it 'has x as nil' do
      expect(robot.x).to be_nil
    end

    it 'has y as nil' do
      expect(robot.y).to be_nil
    end

    it 'has direction as nil' do
      expect(robot.direction).to be_nil
    end

    it 'is not placed on the table' do
      expect(robot.placed_on_table).to be false
    end

    it 'does not move if not placed' do
      expect(robot.move).to be false
      expect(robot.x).to be_nil
    end

    it 'does not turn left if not placed' do
      expect(robot.left).to be false
      expect(robot.direction).to be_nil
    end

    it 'does not turn right if not placed' do
      expect(robot.right).to be false
      expect(robot.direction).to be_nil
    end

    it 'reports nil if not placed' do
      expect(robot.report).to be_nil
    end
  end
end
