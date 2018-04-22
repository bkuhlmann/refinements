# frozen_string_literal: true

module Refinements
  # Refinements for arrays.
  module Arrays
    refine Array do
      def compress
        compact.reject(&:empty?)
      end

      def compress!
        replace(compress)
      end
    end
  end
end
