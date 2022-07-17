# frozen_string_literal: true

require "refinements/log_devices"

module Refinements
  # Provides additional enhancements to a logger.
  module Loggers
    using LogDevices

    refine Logger do
      def reread = @logdev.reread
    end
  end
end
