# frozen_string_literal: true

module TableTopBot
  class Robot
    attr_reader :table

    def initialize
      @table = Table.new
    end
  end
end
