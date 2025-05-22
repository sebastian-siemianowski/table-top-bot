# frozen_string_literal: true

module TableTopBot
  class Direction
    attr_reader :directions

    def initialize
      @directions = ['NORTH', 'EAST', 'SOUTH', 'WEST']
    end

    def turn_left(current_direction)
      current_index = @directions.index(current_direction)
      return nil unless current_index

      new_index = (current_index - 1 + @directions.length) % @directions.length
      @directions[new_index]
    end

    def turn_right(current_direction)
      current_index = @directions.index(current_direction)
      return nil unless current_index

      new_index = (current_index + 1) % @directions.length
      @directions[new_index]
    end

    def valid?(direction)
      @directions.include?(direction)
    end
  end
end
