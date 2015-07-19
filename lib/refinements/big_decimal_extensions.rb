require "bigdecimal"

module Refinements
  module BigDecimalExtensions
    refine BigDecimal do
      def inspect
        format "#<BigDecimal:%x %s>", object_id, to_s("F")
      end
    end
  end
end
