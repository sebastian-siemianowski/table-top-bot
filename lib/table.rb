# frozen_string_literal: true

module TableTopBot
  # This class represents the tabletop, which is a grid where the robot moves.
  # By default, it's a 5x5 unit grid.
  class Table
    attr_accessor :width, :height

    def initialize
      @width = 5
      @height = 5
    end

    # This method checks if a given pair of x and y coordinates are valid,
    # meaning they are actual integer positions on the tabletop grid and not outside its boundaries.
    # It returns true if the position is valid, and false otherwise.
    def valid_position?(x_coordinate:, y_coordinate:)
      x_coordinate.is_a?(Integer) && y_coordinate.is_a?(Integer) &&
        x_coordinate >= 0 && x_coordinate < @width &&
        y_coordinate >= 0 && y_coordinate < @height
    end
  end
end
