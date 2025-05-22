# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::Simulator do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  subject(:simulator) { described_class.new(input, output) }

  describe '#process_command' do
    context 'with PLACE command' do
      it 'correctly places the robot for "PLACE 0,0,NORTH"' do
        simulator.process_command('PLACE 0,0,NORTH')
        robot = simulator.robot
        expect(robot.x).to eq(0)
        expect(robot.y).to eq(0)
        expect(robot.direction).to eq('NORTH')
        expect(robot.placed_on_table).to be true
      end

      it 'handles case-insensitivity for direction "PLACE 1,2,east"' do
        simulator.process_command('PLACE 1,2,east')
        robot = simulator.robot
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
        expect(robot.direction).to eq('EAST')
        expect(robot.placed_on_table).to be true
      end

      it 'handles extra spaces "   PLACE 0,0,NORTH   "' do
        simulator.process_command('   PLACE 0,0,NORTH   ')
        robot = simulator.robot
        expect(robot.x).to eq(0)
        expect(robot.y).to eq(0)
        expect(robot.direction).to eq('NORTH')
        expect(robot.placed_on_table).to be true
      end

      it 'handles place command with mixed case "PlAcE 0,0,NoRtH"' do
        simulator.process_command('PlAcE 0,0,NoRtH')
        robot = simulator.robot
        expect(robot.x).to eq(0)
        expect(robot.y).to eq(0)
        expect(robot.direction).to eq('NORTH')
        expect(robot.placed_on_table).to be true
      end

      context 'malformed PLACE commands' do
        it 'ignores "PLACE 1,NORTH" (missing Y) - robot state unchanged' do
          simulator.process_command('PLACE 1,NORTH')
          robot = simulator.robot
          expect(robot.placed_on_table).to be false
        end

        it 'processes "PLACE 1,2,INVALID_DIRECTION" but robot remains unplaced' do
          simulator.process_command('PLACE 1,2,INVALID_DIRECTION')
          robot = simulator.robot
          expect(robot.placed_on_table).to be false
        end

        it 'ignores "PLACE" (missing arguments) - robot state unchanged' do
          simulator.process_command('PLACE')
          robot = simulator.robot
          expect(robot.placed_on_table).to be false
        end

        it 'ignores "PLACE A,B,NORTH" (non-integer coordinates) - robot state unchanged' do
          simulator.process_command('PLACE A,B,NORTH')
          robot = simulator.robot
          expect(robot.placed_on_table).to be false
        end

        it 'ignores "PLACE 1,B,NORTH" - robot state unchanged' do
          simulator.process_command('PLACE 1,B,NORTH')
          robot = simulator.robot
          expect(robot.placed_on_table).to be false
        end

        it 'ignores "PLACE A,2,NORTH" - robot state unchanged' do
          simulator.process_command('PLACE A,2,NORTH')
          robot = simulator.robot
          expect(robot.placed_on_table).to be false
        end
      end
    end

    context 'with MOVE command' do
      before do
        simulator.process_command('PLACE 0,0,NORTH')
      end

      it 'moves the robot correctly for "MOVE"' do
        simulator.process_command('MOVE')
        robot = simulator.robot
        expect(robot.y).to eq(1)
        expect(robot.x).to eq(0)
      end

      it 'moves the robot correctly for "move" (case-insensitive)' do
        simulator.process_command('move')
        robot = simulator.robot
        expect(robot.y).to eq(1)
        expect(robot.x).to eq(0)
      end
    end

    context 'with LEFT command' do
      before do
        simulator.process_command('PLACE 0,0,NORTH')
      end

      it 'turns the robot left for "LEFT"' do
        simulator.process_command('LEFT')
        robot = simulator.robot
        expect(robot.direction).to eq('WEST')
      end

      it 'turns the robot left for "left" (case-insensitive)' do
        simulator.process_command('left')
        robot = simulator.robot
        expect(robot.direction).to eq('WEST')
      end
    end

    context 'with RIGHT command' do
      before do
        simulator.process_command('PLACE 0,0,NORTH')
      end

      it 'turns the robot right for "RIGHT"' do
        simulator.process_command('RIGHT')
        robot = simulator.robot
        expect(robot.direction).to eq('EAST')
      end

      it 'turns the robot right for "right" (case-insensitive)' do
        simulator.process_command('right')
        robot = simulator.robot
        expect(robot.direction).to eq('EAST')
      end
    end

    context 'with REPORT command' do
      it 'prints to output if robot is placed' do
        simulator.process_command('PLACE 1,2,SOUTH')
        simulator.process_command('REPORT')
        expect(output.string).to eq("1,2,SOUTH\n")
      end

      it 'prints to output for "report" (case-insensitive) if robot is placed' do
        simulator.process_command('PLACE 0,0,NORTH')
        simulator.process_command('report')
        expect(output.string).to eq("0,0,NORTH\n")
      end

      it 'does not print to output if robot is not placed' do
        simulator.process_command('REPORT')
        expect(output.string).to be_empty
      end
    end

    context 'with unknown commands' do
      before do
        simulator.process_command('PLACE 0,0,NORTH')
      end

      it 'ignores "JUMP" and robot state is unchanged' do
        robot_before = simulator.robot
        x_before = robot_before.x
        y_before = robot_before.y
        direction_before = robot_before.direction

        simulator.process_command('JUMP')

        robot_after = simulator.robot
        expect(robot_after.x).to eq(x_before)
        expect(robot_after.y).to eq(y_before)
        expect(robot_after.direction).to eq(direction_before)
        expect(output.string).to be_empty
      end

      it 'ignores "INVALID COMMAND" and output is empty' do
        simulator.process_command('INVALID COMMAND')
        expect(output.string).to be_empty
      end

      it 'ignores empty command string and output is empty' do
        simulator.process_command('')
        expect(output.string).to be_empty
      end
    end
  end

  describe '#run' do
    it 'processes a sequence: PLACE 0,0,NORTH; MOVE; REPORT -> 0,1,NORTH' do
      input.string = "PLACE 0,0,NORTH\nMOVE\nREPORT\n"
      simulator.run
      expect(output.string).to eq("0,1,NORTH\n")
    end

    it 'processes a sequence: PLACE 0,0,NORTH; LEFT; REPORT -> 0,0,WEST' do
      input.string = "PLACE 0,0,NORTH\nLEFT\nREPORT\n"
      simulator.run
      expect(output.string).to eq("0,0,WEST\n")
    end

    it 'processes a sequence: PLACE 1,2,EAST; MOVE; MOVE; LEFT; MOVE; REPORT -> 3,3,NORTH' do
      input.string = "PLACE 1,2,EAST\nMOVE\nMOVE\nLEFT\nMOVE\nREPORT\n"
      simulator.run
      expect(output.string).to eq("3,3,NORTH\n")
    end

    it 'handles commands before a valid PLACE' do
      input.string = "MOVE\nLEFT\nPLACE 0,0,NORTH\nREPORT\n"
      simulator.run
      expect(output.string).to eq("0,0,NORTH\n")
    end

    it 'handles multiple PLACE commands and complex sequence' do
      input_str = <<~COMMANDS
        PLACE 0,0,NORTH
        MOVE
        REPORT
        PLACE 0,0,NORTH
        LEFT
        REPORT
        PLACE 1,2,EAST
        MOVE
        MOVE
        LEFT
        MOVE
        REPORT
      COMMANDS
      input.string = input_str

      simulator.run
      expect(output.string).to eq("0,1,NORTH\n0,0,WEST\n3,3,NORTH\n")
    end
  end
end
