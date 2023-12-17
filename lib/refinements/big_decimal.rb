# frozen_string_literal: true

require "bigdecimal"

module Refinements
  # Provides additional enhancements to the BigDecimal primitive.
  module BigDecimal
    refine ::BigDecimal do
      def inspect = format("#<BigDecimal:%<id>s %<string>s>", id: object_id, string: to_s("F"))
    end
  end
end
