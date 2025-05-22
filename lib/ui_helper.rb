# frozen_string_literal: true

require 'colorize'

module TableTopBot
  module UIHelper
    # The UIHelper module is a collection of simple tools (methods) to help make the
    # program's text output more user-friendly and visually clear. It uses the 'colorize'
    # gem to display different types of messages in different colors.

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
