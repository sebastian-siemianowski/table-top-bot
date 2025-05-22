# frozen_string_literal: true

module TableTopBot
  # This class is responsible for managing the robot's orientation (which way it's facing).
  # It knows about the cardinal directions (NORTH, SOUTH, EAST, WEST) and how to change
  # the robot's direction when it turns left or right.
  class Direction
    attr_reader :directions

    def initialize
      @directions = ['NORTH', 'EAST', 'SOUTH', 'WEST']
    end

    # This method calculates the new direction when the robot turns left.
    # It finds the robot's current direction in the list, then picks the one
    # to its "left" (or wraps around to the end of the list if currently facing NORTH).
    # If the current direction isn't valid, it returns nothing (nil).
    def turn_left(current_direction)
      current_index = @directions.index(current_direction)
      return nil unless current_index

      new_index = (current_index - 1 + @directions.length) % @directions.length
      @directions[new_index]
    end

    # This method calculates the new direction when the robot turns right.
    # It's similar to turning left, but it picks the direction to the "right"
    # in the list (or wraps around to the beginning if currently facing WEST).
    # If the current direction isn't valid, it returns nothing (nil).
    def turn_right(current_direction)
      current_index = @directions.index(current_direction)
      return nil unless current_index

      new_index = (current_index + 1) % @directions.length
      @directions[new_index]
    end

    # This method simply checks if a given direction (like "NORTH" or "SOMEWHERE_ELSE")
    # is one of the known, valid directions stored in the @directions list.
    # It returns true if it's valid, and false if it's not.
    def valid?(direction)
      @directions.include?(direction)
    end
  end
end
