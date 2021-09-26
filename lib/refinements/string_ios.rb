# frozen_string_literal: true

require "stringio"

module Refinements
  # Provides additional enhancements to the StringIO primitive.
  module StringIOs
    refine StringIO do
      def reread(length = nil, buffer: nil) = tap(&:rewind).read(length, buffer)
    end
  end
end
