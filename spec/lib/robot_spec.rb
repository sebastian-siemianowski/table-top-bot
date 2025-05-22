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

  describe '#place' do
    it 'places the robot correctly with valid arguments' do
      expect(robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')).to be true
      expect(robot.x).to eq(0)
      expect(robot.y).to eq(0)
      expect(robot.direction).to eq('NORTH')
      expect(robot.placed_on_table).to be true
    end

    it 'does not place the robot with invalid x coordinate (off table)' do
      expect(robot.place(x_coordinate: 5, y_coordinate: 0, direction: 'NORTH')).to be false
      expect(robot.placed_on_table).to be false
    end

    it 'does not place the robot with invalid y coordinate (off table)' do
      expect(robot.place(x_coordinate: 0, y_coordinate: 5, direction: 'NORTH')).to be false
      expect(robot.placed_on_table).to be false
    end

    it 'does not place the robot with negative x coordinate' do
      expect(robot.place(x_coordinate: -1, y_coordinate: 0, direction: 'NORTH')).to be false
      expect(robot.placed_on_table).to be false
    end

    it 'does not place the robot with negative y coordinate' do
      expect(robot.place(x_coordinate: 0, y_coordinate: -1, direction: 'NORTH')).to be false
      expect(robot.placed_on_table).to be false
    end

    it 'does not place the robot with an invalid direction' do
      expect(robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'INVALID_DIRECTION')).to be false
      expect(robot.placed_on_table).to be false
    end

    it 'returns false if x_coordinate is not an integer' do
      expect(robot.place(x_coordinate: 'a', y_coordinate: 0, direction: 'NORTH')).to be false
      expect(robot.placed_on_table).to be false
    end

    it 'returns false if y_coordinate is not an integer' do
      expect(robot.place(x_coordinate: 0, y_coordinate: 'b', direction: 'NORTH')).to be false
      expect(robot.placed_on_table).to be false
    end

    it 'allows re-placing the robot successfully' do
      robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')
      expect(robot.place(x_coordinate: 1, y_coordinate: 1, direction: 'SOUTH')).to be true
      expect(robot.x).to eq(1)
      expect(robot.y).to eq(1)
      expect(robot.direction).to eq('SOUTH')
      expect(robot.placed_on_table).to be true
    end

    it 'does not change state if re-placing with invalid arguments after a valid place' do
      robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')
      expect(robot.place(x_coordinate: 10, y_coordinate: 10, direction: 'EAST')).to be false
      expect(robot.x).to eq(0)
      expect(robot.y).to eq(0)
      expect(robot.direction).to eq('NORTH') # State from previous valid place
      expect(robot.placed_on_table).to be true
    end
  end

  context 'when robot is placed' do
    before do
      robot.place(x_coordinate: 1, y_coordinate: 2, direction: 'EAST')
    end

    describe '#move' do
      it 'moves EAST correctly' do
        robot.place(x_coordinate: 1, y_coordinate: 1, direction: 'EAST')
        expect(robot.move).to be true
        expect(robot.x).to eq(2)
        expect(robot.y).to eq(1)
      end

      it 'moves WEST correctly' do
        robot.place(x_coordinate: 1, y_coordinate: 1, direction: 'WEST')
        expect(robot.move).to be true
        expect(robot.x).to eq(0)
        expect(robot.y).to eq(1)
      end

      it 'moves NORTH correctly' do
        robot.place(x_coordinate: 1, y_coordinate: 1, direction: 'NORTH')
        expect(robot.move).to be true
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
      end

      it 'moves SOUTH correctly' do
        robot.place(x_coordinate: 1, y_coordinate: 1, direction: 'SOUTH')
        expect(robot.move).to be true
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(0)
      end

      context 'boundary conditions' do
        it 'does not move NORTH from top edge (0,4,NORTH)' do
          robot.place(x_coordinate: 0, y_coordinate: 4, direction: 'NORTH')
          expect(robot.move).to be false
          expect(robot.x).to eq(0)
          expect(robot.y).to eq(4)
        end

        it 'does not move EAST from right edge (4,0,EAST)' do
          robot.place(x_coordinate: 4, y_coordinate: 0, direction: 'EAST')
          expect(robot.move).to be false
          expect(robot.x).to eq(4)
          expect(robot.y).to eq(0)
        end

        it 'does not move SOUTH from bottom edge (0,0,SOUTH)' do
          robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'SOUTH')
          expect(robot.move).to be false
          expect(robot.x).to eq(0)
          expect(robot.y).to eq(0)
        end

        it 'does not move WEST from left edge (0,0,WEST)' do
          robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'WEST')
          expect(robot.move).to be false
          expect(robot.x).to eq(0)
          expect(robot.y).to eq(0)
        end
      end
    end

    describe '#left' do
      it 'turns left from EAST to NORTH' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'EAST')
        expect(robot.left).to be true
        expect(robot.direction).to eq('NORTH')
      end

      it 'turns left from NORTH to WEST' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')
        expect(robot.left).to be true
        expect(robot.direction).to eq('WEST')
      end

      it 'turns left from WEST to SOUTH' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'WEST')
        expect(robot.left).to be true
        expect(robot.direction).to eq('SOUTH')
      end

      it 'turns left from SOUTH to EAST' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'SOUTH')
        expect(robot.left).to be true
        expect(robot.direction).to eq('EAST')
      end
    end

    describe '#right' do
      it 'turns right from EAST to SOUTH' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'EAST')
        expect(robot.right).to be true
        expect(robot.direction).to eq('SOUTH')
      end

      it 'turns right from SOUTH to WEST' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'SOUTH')
        expect(robot.right).to be true
        expect(robot.direction).to eq('WEST')
      end

      it 'turns right from WEST to NORTH' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'WEST')
        expect(robot.right).to be true
        expect(robot.direction).to eq('NORTH')
      end

      it 'turns right from NORTH to EAST' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')
        expect(robot.right).to be true
        expect(robot.direction).to eq('EAST')
      end
    end

    describe '#report' do
      it 'reports current position and direction' do
        robot.place(x_coordinate: 1, y_coordinate: 2, direction: 'EAST')
        expect(robot.report).to eq('1,2,EAST')
      end

      it 'reports correctly after a move' do
        robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')
        robot.move
        expect(robot.report).to eq('0,1,NORTH')
      end
    end
  end

  describe 'sequence of commands' do
    it 'handles PLACE 0,0,NORTH; MOVE; REPORT -> 0,1,NORTH' do
      expect(robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')).to be true
      expect(robot.move).to be true
      expect(robot.report).to eq('0,1,NORTH')
    end

    it 'handles PLACE 0,0,NORTH; LEFT; REPORT -> 0,0,WEST' do
      expect(robot.place(x_coordinate: 0, y_coordinate: 0, direction: 'NORTH')).to be true
      expect(robot.left).to be true
      expect(robot.report).to eq('0,0,WEST')
    end

    it 'handles PLACE 1,2,EAST; MOVE; MOVE; LEFT; MOVE; REPORT -> 3,3,NORTH' do
      expect(robot.place(x_coordinate: 1, y_coordinate: 2, direction: 'EAST')).to be true
      expect(robot.move).to be true # 2,2,EAST
      expect(robot.move).to be true # 3,2,EAST
      expect(robot.left).to be true # 3,2,NORTH
      expect(robot.move).to be true # 3,3,NORTH
      expect(robot.report).to eq('3,3,NORTH')
    end
  end
end
