# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Array primitive.
  module Arrays
    refine Array do
      def compress = dup.compress!

      def compress!
        compact!
        delete_if { |element| element.respond_to?(:empty?) && element.empty? }
      end

      def excluding(*elements) = self - elements.flatten

      def filter_find(&block) = block ? lazy.map(&block).find(&:itself) : lazy

      def including(*elements) = self + elements.flatten

      def intersperse(*elements) = product([elements]).tap(&:pop).flatten.push(last)

      def maximum(key) = map(&key).max

      def mean = size.zero? ? 0 : sum(0.0) / size

      def minimum(key) = map(&key).min

      def pad(value, max: size) = dup.fill(value, size..(max - 1))

      def ring(&) = [last, *self, first].each_cons(3, &)
    end
  end
end
