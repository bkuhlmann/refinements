# frozen_string_literal: true

require "date"

module Refinements
  # Provides additional enhancements to the DateTime primitive.
  module DateTime
    refine ::DateTime.singleton_class do
      def utc
        warn "`DateTime.#{__method__}` is deprecated, use `Time` instead.", category: :deprecated
        now.new_offset 0
      end
    end
  end
end
