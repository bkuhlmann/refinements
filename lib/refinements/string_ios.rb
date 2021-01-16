# frozen_string_literal: true

require "stringio"

module Refinements
  module StringIOs
    refine StringIO do
      def reread(length = nil, buffer: nil) = tap(&:rewind).read(length, buffer)
    end
  end
end
