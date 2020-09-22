# frozen_string_literal: true

module Refinements
  module Strings
    DELIMITERS = %r([a-z][A-Z]|\s*-\s*|\s*/\s*|\s*:+\s*|\s*_\s*|\s+).freeze

    refine String.singleton_class do
      def delimiters
        warn "[DEPRECATION]: .delimiters is deprecated, use DELIMITERS instead."
        DELIMITERS
      end
    end

    refine String do
      def first number = 0
        return self if empty?

        max = Integer number

        return self[0] if max.zero?
        return "" if max.negative?

        self[..(max - 1)]
      end

      def last number = 0
        return self if empty?

        min = Integer number

        return self[size - 1] if min.zero?
        return "" if min.negative?

        self[(min + 1)..]
      end

      def blank?
        match?(/\A\s*\z/)
      end

      def up
        return self if empty?

        first.upcase + self[1, size]
      end

      def down
        return self if empty?

        first.downcase + self[1, size]
      end

      def indent multiplier = 1, padding: "  "
        return self if multiplier.negative?

        padding * multiplier + self
      end

      def camelcase
        return up unless match? DELIMITERS

        split(%r(\s*-\s*|\s*/\s*|\s*:+\s*)).then { |parts| combine parts, :up, "::" }
                                           .then { |text| text.split(/\s*_\s*|\s+/) }
                                           .then { |parts| combine parts, :up }
      end

      def snakecase
        return downcase unless match? DELIMITERS

        split(%r(\s*-\s*|\s*/\s*|\s*:+\s*)).then { |parts| combine parts, :down, "/" }
                                           .then { |text| text.split(/(?=[A-Z])|\s*_\s*|\s+/) }
                                           .then { |parts| combine parts, :down, "_" }
      end

      def titleize
        return capitalize unless match? DELIMITERS

        split(/(?=[A-Z])|\s*_\s*|\s*-\s*|\s+/).then { |parts| combine parts, :up, " " }
                                              .then { |text| text.split %r(\s*/\s*|\s*:+\s*) }
                                              .then { |parts| combine parts, :up, "/" }
      end

      def to_bool
        %w[true yes on t y 1].include? downcase.strip
      end

      private

      # :reek:DuplicateMethodCall
      # :reek:UtilityFunction
      def combine parts, method, delimiter = ""
        parts.reduce "" do |result, part|
          next part.__send__ method if result.empty?

          "#{result}#{delimiter}#{part.__send__ method}"
        end
      end
    end
  end
end
