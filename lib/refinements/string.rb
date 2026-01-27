# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the String primitive.
  module String
    DELIMITERS = %r([a-z][A-Z]|\s*-\s*|\s*/\s*|\s*:+\s*|\s*_\s*|\s+)

    refine ::String do
      def blank? = empty? || match?(/\A[[:space:]]*\z/)

      def camelcase
        return up unless match? DELIMITERS

        split(%r(\s*-\s*|\s*/\s*|\s*:+\s*)).then { |parts| combine parts, :up, "::" }
                                           .then { |text| text.split(/\s*_\s*|\s+/) }
                                           .then { |parts| combine parts, :up }
      end

      def down = empty? ? self : first.downcase + self[1, size]

      def falsey? = !truthy?

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
        return self[-1] if minimum.zero?
        return "" if minimum.negative?

        self[(minimum + 1)..]
      end

      def pluralize(suffix, count = 0, replace: /$/) = count.abs == 1 ? self : sub(replace, suffix)

      def singularize(suffix, count = 1, replace: "") = count.abs == 1 ? sub(suffix, replace) : self

      def snakecase
        return downcase unless match? DELIMITERS

        split(%r(\s*-\s*|\s*/\s*|\s*:+\s*)).then { |parts| combine parts, :down, "/" }
                                           .then { |text| text.split(/(?=[A-Z])|\s*_\s*|\s+/) }
                                           .then { |parts| combine parts, :down, "_" }
      end

      def squish
        duplicate = dup

        # Find two or more spaces/tabs/newlines or a single space that isn't " ".
        duplicate.gsub!(/([[:space:]]{2,}|[[[:space:]]&&[^ ]])/, " ")

        duplicate.strip!
        duplicate
      end

      def titleize
        return capitalize unless match? DELIMITERS

        split(/(?=[A-Z])|\s*_\s*|\s*-\s*|\s+/).then { |parts| combine parts, :up, " " }
                                              .then { |text| text.split %r(\s*/\s*|\s*:+\s*) }
                                              .then { |parts| combine parts, :up, "/" }
      end

      def trim_end maximum, delimiter = nil, trailer: "..."
        return dup if size <= maximum

        offset = maximum - trailer.size
        stop = delimiter ? rindex(delimiter, offset) || offset : offset
        "#{self[...stop]}#{trailer}"
      end

      def trim_middle maximum, gap: "..."
        gap_size = gap.size
        minimum = gap_size + 2
        limit = maximum - gap_size

        return dup if maximum < minimum || maximum > size
        return "#{first}#{gap}#{last}" if minimum == maximum

        half = limit / 2
        stop = half.odd? ? half - 1 : half

        "#{self[...stop]}#{gap}#{self[-half...]}"
      end

      def truthy? = %w[true yes on t y 1].include? downcase.strip

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
