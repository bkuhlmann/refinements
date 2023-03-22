# frozen_string_literal: true

require "refinements/log_devices"

module Refinements
  # Provides additional enhancements to a logger.
  module Loggers
    using LogDevices

    refine Logger do
      def reread = @logdev.reread

      alias_method :any, :unknown
    end
  end
end
