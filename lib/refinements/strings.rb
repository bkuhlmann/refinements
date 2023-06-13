# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the String primitive.
  module Strings
    DELIMITERS = %r([a-z][A-Z]|\s*-\s*|\s*/\s*|\s*:+\s*|\s*_\s*|\s+)

    refine String do
      def blank? = empty? || match?(/\A[[:space:]]*\z/)

      def camelcase
        return up unless match? DELIMITERS

        split(%r(\s*-\s*|\s*/\s*|\s*:+\s*)).then { |parts| combine parts, :up, "::" }
                                           .then { |text| text.split(/\s*_\s*|\s+/) }
                                           .then { |parts| combine parts, :up }
      end

      def down = empty? ? self : first.downcase + self[1, size]

      def first maximum = 0
        return self if empty?
        return self[0] if maximum.zero?
        return "" if maximum.negative?

        self[..(maximum - 1)]
      end

      def indent multiplier = 1, pad: "  "
        multiplier.negative? ? self : (pad * multiplier) + self
      end

      def last minimum = 0
        return self if empty?
        return self[size - 1] if minimum.zero?
        return "" if minimum.negative?

        self[(minimum + 1)..]
      end

      def pluralize(suffix, replace: /$/, count: 0) = count.abs == 1 ? self : sub(replace, suffix)

      def singularize(suffix, replace: "", count: 1) = count.abs == 1 ? sub(suffix, replace) : self

      def snakecase
        return downcase unless match? DELIMITERS

        split(%r(\s*-\s*|\s*/\s*|\s*:+\s*)).then { |parts| combine parts, :down, "/" }
                                           .then { |text| text.split(/(?=[A-Z])|\s*_\s*|\s+/) }
                                           .then { |parts| combine parts, :down, "_" }
      end

      def squish = gsub(/[[:space:]]+/, " ").tap(&:strip!)

      def titleize
        return capitalize unless match? DELIMITERS

        split(/(?=[A-Z])|\s*_\s*|\s*-\s*|\s+/).then { |parts| combine parts, :up, " " }
                                              .then { |text| text.split %r(\s*/\s*|\s*:+\s*) }
                                              .then { |parts| combine parts, :up, "/" }
      end

      def to_bool = %w[true yes on t y 1].include?(downcase.strip)

      def up = empty? ? self : first.upcase + self[1, size]

      private

      # :reek:UtilityFunction
      def combine parts, method, delimiter = ""
        parts.reduce "" do |result, part|
          next part.public_send method if result.empty?

          "#{result}#{delimiter}#{part.__send__ method}"
        end
      end
    end
  end
end
