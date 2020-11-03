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

      def include *elements
        self + elements.flatten
      end

      def intersperse *elements
        product([elements]).tap(&:pop).flatten.push last
      end

      def exclude *elements
        self - elements.flatten
      end

      def ring &block
        [last, *self, first].each_cons 3, &block
      end
    end
  end
end
