# frozen_string_literal: true

module TableTopBot
  class Direction
    attr_reader :directions
    def initialize
      @directions = ['NORTH', 'EAST', 'SOUTH', 'WEST']
    end

    def self.valid?(direction)
      @directions.include?(direction)
    end
  end
end
