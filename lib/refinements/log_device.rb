# frozen_string_literal: true

require "logger"
require "refinements/string_io"

module Refinements
  # Provides additional enhancements to a log device.
  module LogDevice
    using StringIO

    refine ::Logger::LogDevice do
      def reread
        case dev
          when ::File then dev.class.new(dev).read
          when ::StringIO then dev.reread
          else ""
        end
      end
    end
  end
end
