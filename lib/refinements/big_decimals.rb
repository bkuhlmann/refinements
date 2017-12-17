# frozen_string_literal: true

require "bigdecimal"

module Refinements
  # Refinements for Big Decimals.
  module BigDecimals
    refine BigDecimal do
      def inspect
        format "#<BigDecimal:%{id} %{string}>", id: object_id, string: to_s("F")
      end
    end
  end
end
