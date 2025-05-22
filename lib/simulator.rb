# frozen_string_literal: true

require_relative 'robot'
require_relative 'direction'
require_relative 'table'
require_relative 'ui_helper'

module TableTopBot
  class Simulator
    attr_reader :robot

    def initialize(input_stream: $stdin, output_stream: $stdout)
      @input_stream = input_stream
      @output_stream = output_stream
      @robot = TableTopBot::Robot.new
    end

    def run
      loop do
        line = @input_stream.gets
        break if line.nil?

        command_string = line.strip

        result = process_command(command_string)
        break if result == :exit
      end
    end

    def process_command(command_string)
      command_string = command_string.strip
      return if command_string.empty?

      parts = command_string.split(/\s+/, 2) # Split into command and potential arguments
      command_keyword = parts[0].upcase # Case-insensitive command
      args_str = parts[1]

      case command_keyword
      when 'PLACE'  then handle_place_command(args_str)
      when 'MOVE'   then handle_move_command
      when 'LEFT'   then handle_left_command
      when 'RIGHT'  then handle_right_command
      when 'REPORT' then handle_report_command
      when 'EXIT'   then return :exit
        # Unknown commands are silently ignored, returning nil implicitly
      end
      nil # Default return for commands that don't exit
    end

    private

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

    def handle_report_command
      report_output = @robot.report
      TableTopBot::UIHelper.success(report_output, stream: @output_stream) if report_output
    end

    def parse_place_arguments(args_str)
      return nil unless args_str # Guard against missing arguments string

      args = args_str.split(',')
      return nil unless args.length == 3 # Must have X, Y, and F components

      x_str, y_str, direction_str = args.map(&:strip) # Strip whitespace from each part

      # Convert coordinates to integers; rescue if conversion fails
      x_coordinate = Integer(x_str)
      y_coordinate = Integer(y_str)

      # Direction should be uppercase. Robot's place method handles validation.
      [x_coordinate, y_coordinate, direction_str.upcase]
    rescue ArgumentError, TypeError # Catches errors from Integer() or if a part is nil
      nil # Indicates parsing failure
    end
  end
end
