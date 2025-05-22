# frozen_string_literal: true

require_relative 'table'
require_relative 'direction'

module TableTopBot
  # This class is all about the toy robot. It keeps track of where the robot is on the table,
  # which direction it's facing, and what actions it can perform, like moving or turning.
  class Robot
    # These attributes store the robot's current state:
    # `table`: The Table object the robot is on.
    # `x`, `y`: The robot's current coordinates (x and y position) on the table.
    # `direction`: Which way the robot is currently facing (NORTH, SOUTH, EAST, or WEST).
    # `placed_on_table`: A flag (true/false) indicating if the robot has been successfully placed on the table yet.
    attr_reader :table, :x, :y, :direction, :placed_on_table

    alias x_coordinate x
    alias y_coordinate y

    # Initially, the robot isn't on any specific table square and isn't facing any direction.
    # It also gets its own Table object to interact with.
    # The `placed_on_table` flag is set to false because it hasn't been placed yet.
    def initialize
      @table = Table.new
      @x = nil
      @y = nil
      @direction = nil
      @placed_on_table = false
    end

    # This method handles the PLACE command. It tries to put the robot on the table
    # at a specific (x,y) spot, facing a certain direction.
    # Before placing, it checks two things:
    # 1. Is the direction valid (NORTH, SOUTH, EAST, WEST)?
    # 2. Is the (x,y) position a valid spot on the table?
    # If both are okay, the robot's position and direction are updated,
    # and the `placed_on_table` flag is set to true. It returns true if successful, false otherwise.
    def place(x_coordinate:, y_coordinate:, direction:)
      return false unless TableTopBot::Direction.new.valid?(direction)
      return false unless @table.valid_position?(x_coordinate: x_coordinate, y_coordinate: y_coordinate)

      @x = x_coordinate
      @y = y_coordinate
      @direction = direction
      @placed_on_table = true
      true
    end

    # This method handles the MOVE command. The robot moves one step forward
    # in the direction it's currently facing.
    # It only works if the robot has already been placed on the table.
    # Before moving, it calculates where it *would* land (using `calculate_next_position`)
    # and then checks if that new spot is actually on the table.
    # If the move is safe, the robot's position is updated. If not, it stays put.
    # Returns true if the move was successful, false otherwise.
    def move
      return false unless @placed_on_table

      next_x_coord, next_y_coord = calculate_next_position

      if @table.valid_position?(x_coordinate: next_x_coord, y_coordinate: next_y_coord)
        @x = next_x_coord
        @y = next_y_coord
        true
      else
        false
      end
    end

    # This method handles the LEFT command. The robot turns 90 degrees to its left,
    # changing the direction it's facing but not its position on the table.
    # It only works if the robot has already been placed on the table.
    # Returns true if the turn was successful, false if not placed.
    def left
      return false unless @placed_on_table

      @direction = TableTopBot::Direction.new.turn_left(@direction)
      true
    end

    # This method handles the RIGHT command. The robot turns 90 degrees to its right,
    # changing the direction it's facing but not its position on the table.
    # It only works if the robot has already been placed on the table.
    # Returns true if the turn was successful, false if not placed.
    def right
      return false unless @placed_on_table

      @direction = TableTopBot::Direction.new.turn_right(@direction)
      true
    end

    # This method handles the REPORT command. It gives back the robot's current
    # x coordinate, y coordinate, and the direction it's facing, as a string
    # like "X,Y,DIRECTION" (e.g., "0,1,NORTH").
    # If the robot hasn't been placed on the table yet, it returns nothing (nil).
    def report
      return nil unless @placed_on_table

      "#{@x},#{@y},#{@direction}"
    end

    private

    # This is a helper method used internally by the `move` method.
    # It figures out what the robot's next x and y coordinates would be if it took one step
    # forward from its current position and direction.
    # It returns the potential new x and y coordinates.
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
