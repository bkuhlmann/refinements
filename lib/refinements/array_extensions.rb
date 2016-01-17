# frozen_string_literal: true

module Refinements
  # Refinements for Arrays.
  module ArrayExtensions
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
