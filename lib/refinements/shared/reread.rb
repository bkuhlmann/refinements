# frozen_string_literal: true

module Refinements
  module Shared
    # Provides functionality for I/O object rewinding.
    module Reread
      def reread(length = nil, buffer: nil) = tap(&:rewind).read(length, buffer)
    end
  end
end
