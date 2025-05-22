# frozen_string_literal: true

module TableTopBot
  class Table
    attr_accessor :width, :height

    def initialize
      @width = 5
      @height = 5
    end

    def valid_position?(x_coordinate:, y_coordinate:)
      x_coordinate.is_a?(Integer) && y_coordinate.is_a?(Integer) &&
        x_coordinate >= 0 && x_coordinate < @width &&
        y_coordinate >= 0 && y_coordinate < @height
    end
  end
end
