# frozen_string_literal: true

require "refinements/shared/enumerables/many"

module Refinements
  # Provides additional enhancements to the Array primitive.
  module Arrays
    refine Array do
      import_methods Shared::Enumerables::Many

      def combinatorial?(other) = !other.empty? && size == union(other).size

      def compress = compact.delete_if { |element| element.respond_to?(:empty?) && element.empty? }

      def compress!
        delete_if { |element| element.respond_to?(:empty?) && element.empty? }
        compact!
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

      def supplant target, *replacements
        index(target).then do |position|
          delete_at position
          insert position, *replacements
        end

        self
      end

      def supplant_if target, *replacements
        each { |item| supplant target, *replacements if item == target }
        self
      end

      def to_sentence delimiter: ", ", conjunction: "and"
        case length
          when (3..) then "#{self[..-2].join delimiter}#{delimiter}#{conjunction} #{last}"
          when 2 then join " #{conjunction} "
          else join
        end
      end
    end
  end
end
