# frozen_string_literal: true

module Refinements
  module Arrays
    refine Array do
      def compress
        compact.reject(&:empty?)
      end

      def compress!
        replace compress
      end

      def excluding *elements
        self - elements.flatten
      end

      def including *elements
        self + elements.flatten
      end

      def intersperse *elements
        product([elements]).tap(&:pop).flatten.push last
      end

      def mean
        size.zero? ? 0 : sum(0) / size
      end

      def pad value, max: size
        dup.fill value, size..(max - 1)
      end

      def ring &block
        [last, *self, first].each_cons 3, &block
      end
    end
  end
end
