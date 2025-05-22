# frozen_string_literal: true

module TableTopBot
  class Robot
    attr_reader :table, :x, :y, :direction, :placed_on_table

    def initialize
      @table = Table.new
      @x = nil
      @y = nil
      @direction = nil
      @placed_on_table = false
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

    def move
      false unless @placed_on_table
    end
  end
end
