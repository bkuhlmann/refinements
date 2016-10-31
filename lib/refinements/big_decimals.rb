# frozen_string_literal: true

require "bigdecimal"

module Refinements
  # Refinements for Big Decimals.
  module BigDecimals
    refine BigDecimal do
      def inspect
        format "#<BigDecimal:%x %s>", object_id, to_s("F")
      end
    end
  end
end
