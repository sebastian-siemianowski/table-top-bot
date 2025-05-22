# frozen_string_literal: true

module TableTopBot
  class Table
    attr_accessor :width, :height

    def initialize
      @width = 5
      @height = 5
    end

    def valid_position?(width: , height:)
      true
    end
  end
end
