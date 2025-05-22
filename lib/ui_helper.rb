# frozen_string_literal: true

module TableTopBot
  module UIHelper
    require 'colorize'

    def self.info(message, stream: $stdout)
      stream.puts message.colorize(:cyan)
    end

    def self.warning(message, stream: $stdout)
      stream.puts message.colorize(:yellow)
    end

    def self.error(message, stream: $stdout)
      stream.puts message.colorize(:red)
    end

    def self.success(message, stream: $stdout)
      stream.puts message.colorize(:green)
    end

    def self.prompt(message, stream: $stdout)
      stream.print message.colorize(:magenta)
    end
  end
end
