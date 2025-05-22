# frozen_string_literal: true

require_relative 'robot'
require_relative 'direction'
require_relative 'table'
require_relative 'ui_helper'

module TableTopBot
  # This Simulator class is the main engine of the toy robot application.
  # It's responsible for reading commands (like from a file or user input),
  # telling the Robot what to do based on those commands, and then showing any output
  # (like the robot's position when a REPORT command is issued).
  class Simulator
    attr_reader :robot

    # This is what happens when we create a new Simulator.
    # It needs to know where to get commands from (`input_stream`) and where to send
    # any output (`output_stream`). By default, it listens to standard input (like your keyboard)
    # and prints to standard output (like your screen).
    # It also creates a new Robot instance for this simulation.
    def initialize(input_stream: $stdin, output_stream: $stdout)
      @input_stream = input_stream
      @output_stream = output_stream
      @robot = TableTopBot::Robot.new
    end

    # The `run` method is the main loop of the simulator.
    # It keeps reading lines of text from the `input_stream`, one by one.
    # Each line is treated as a command string, which is then processed by `process_command`.
    # This loop continues until there are no more lines to read (e.g., end of a file)
    # or until the `process_command` method signals that an 'EXIT' command was received.
    def run
      loop do
        line = @input_stream.gets
        break if line.nil?

        command_string = line.strip

        result = process_command(command_string)
        break if result == :exit
      end
    end

    # The `process_command` method takes a single command string (like "PLACE 0,0,NORTH" or "MOVE"),
    # figures out what action to take, and then performs that action using the robot.
    # It understands commands like PLACE, MOVE, LEFT, RIGHT, REPORT, and EXIT.
    # If it gets a command it doesn't recognize, it just ignores it.
    # If the command is 'EXIT', it returns :exit to signal the `run` loop to stop.
    def process_command(command_string)
      command_string = command_string.strip # Clean up the command string.
      return if command_string.empty? # If the line is blank, just ignore it.

      # Split the command into the main keyword (like "PLACE") and any arguments (like "0,0,NORTH").
      parts = command_string.split(/\s+/, 2)
      command_keyword = parts[0].upcase # Make the command case-insensitive (e.g., "place" becomes "PLACE").
      args_str = parts[1] # This will be nil if there are no arguments.

      # Decide what to do based on the command keyword.
      case command_keyword
      when 'PLACE'  then handle_place_command(args_str)
      when 'MOVE'   then handle_move_command
      when 'LEFT'   then handle_left_command
      when 'RIGHT'  then handle_right_command
      when 'REPORT' then handle_report_command
      when 'EXIT'   then return :exit
        # If the command_keyword doesn't match any of the above,
        # it's an unknown command, and we just ignore it (nothing happens).
      end
      nil
    end

    private

    # This helper method is called when `process_command` sees a 'PLACE' command.
    # It takes the arguments string (e.g., "0,0,NORTH"), tries to parse it into
    # x, y, and direction using `parse_place_arguments`. If successful, it tells the robot to place itself.
    def handle_place_command(args_str)
      parsed_args = parse_place_arguments(args_str)
      return unless parsed_args

      @robot.place(
        x_coordinate: parsed_args[0],
        y_coordinate: parsed_args[1],
        direction: parsed_args[2]
      )
    end

    def handle_move_command
      @robot.move
    end

    def handle_left_command
      @robot.left
    end

    def handle_right_command
      @robot.right
    end

    # This helper is for the 'REPORT' command.
    # It asks the robot for its current status (position and direction)
    # and then uses the UIHelper to print this information to the `output_stream`.
    # If the robot hasn't been placed yet, `report` will return nil, and nothing is printed.
    def handle_report_command
      report_output = @robot.report
      TableTopBot::UIHelper.success(report_output, stream: @output_stream) if report_output
    end

    # This utility method is used by `handle_place_command` to make sense of the
    # arguments given to a PLACE command (e.g., "0,0,NORTH").
    # It tries to split the string by commas, convert the first two parts to numbers (integers),
    # and takes the third part as the direction (uppercased).
    # If the string isn't in the right format (e.g., not enough parts, parts aren't numbers),
    # it returns nil to signal that parsing failed. Otherwise, it returns an array [x, y, direction].
    def parse_place_arguments(args_str)
      return nil unless args_str

      args = args_str.split(',')
      return nil unless args.length == 3

      x_str, y_str, direction_str = args.map(&:strip)
      x_coordinate = Integer(x_str)
      y_coordinate = Integer(y_str)

      [x_coordinate, y_coordinate, direction_str.upcase]
    rescue ArgumentError, TypeError
      nil
    end
  end
end
