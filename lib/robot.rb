# frozen_string_literal: true

require_relative 'table'
require_relative 'direction'

module TableTopBot
  class Robot
    attr_reader :table, :x, :y, :direction, :placed_on_table

    alias x_coordinate x
    alias y_coordinate y

    def initialize
      @table = Table.new
      @x = nil
      @y = nil
      @direction = nil
      @placed_on_table = false
    end

    def place(x_coordinate:, y_coordinate:, direction:)
      return false unless TableTopBot::Direction.new.valid?(direction)
      return false unless @table.valid_position?(x_coordinate: x_coordinate, y_coordinate: y_coordinate)

      @x = x_coordinate
      @y = y_coordinate
      @direction = direction
      @placed_on_table = true
      true
    end

    def move
      return false unless @placed_on_table

      next_x_coord, next_y_coord = calculate_next_position

      if @table.valid_position?(x_coordinate: next_x_coord, y_coordinate: next_y_coord)
        @x = next_x_coord
        @y = next_y_coord
        true
      else
        # Move is invalid, robot stays in its current position
        false
      end
    end

    def left
      return false unless @placed_on_table

      @direction = TableTopBot::Direction.new.turn_left(@direction)
      true
    end

    def right
      return false unless @placed_on_table

      @direction = TableTopBot::Direction.new.turn_right(@direction)
      true
    end

    def report
      return nil unless @placed_on_table

      "#{@x},#{@y},#{@direction}"
    end

    private

    def calculate_next_position
      next_x_coord = @x
      next_y_coord = @y

      case @direction
      when 'NORTH' then next_y_coord += 1
      when 'SOUTH' then next_y_coord -= 1
      when 'EAST'  then next_x_coord += 1
      when 'WEST'  then next_x_coord -= 1
      end
      [next_x_coord, next_y_coord]
    end
  end
end
