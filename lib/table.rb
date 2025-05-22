# frozen_string_literal: true

module TableTopBot
  class Table
    attr_accessor :width, :height

    def initialize
      @width = 5
      @height = 5
    end

    def valid_position?(width:, height:)
      width.is_a?(Integer) && height.is_a?(Integer) &&
        width >= 0 && width < @width &&
        height >= 0 && height < @height
    end
  end
end
