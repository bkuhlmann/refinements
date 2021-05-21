# frozen_string_literal: true

module Refinements
  module Arrays
    refine Array do
      def compress = compact.reject(&:empty?)

      def compress! = replace(compress)

      def excluding(*elements) = self - elements.flatten

      def filter_find(&block) = block ? lazy.map(&block).find(&:itself) : lazy

      def including(*elements) = self + elements.flatten

      def intersperse(*elements) = product([elements]).tap(&:pop).flatten.push(last)

      def maximum(key) = map(&key).max

      def mean = size.zero? ? 0 : sum(0) / size

      def minimum(key) = map(&key).min

      def pad(value, max: size) = dup.fill(value, size..(max - 1))

      def ring(&block) = [last, *self, first].each_cons(3, &block)
    end
  end
end
