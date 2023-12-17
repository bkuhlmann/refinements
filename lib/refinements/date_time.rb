# frozen_string_literal: true

require "date"

module Refinements
  # Provides additional enhancements to the DateTime primitive.
  module DateTime
    refine ::DateTime.singleton_class do
      def utc = now.new_offset(0)
    end
  end
end
