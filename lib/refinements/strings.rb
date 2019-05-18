# frozen_string_literal: true

module Refinements
  # Refinements for strings.
  module Strings
    refine String.singleton_class do
      def delimiters
        %r([a-z][A-Z]|\s*\-\s*|\s*\/\s*|\s*\:+\s*|\s*\_\s*|\s+)
      end
    end

    refine String do
      def first number = 0
        return self if empty?

        max = Integer number

        return self[0] if max.zero?
        return "" if max.negative?

        self[0..(max - 1)]
      end

      # :reek:TooManyStatements
      def last number = 0
        return self if empty?

        min = Integer number
        max = size - 1

        return self[max] if min.zero?
        return "" if min.negative?

        self[(min + 1)..max]
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

      def camelcase
        if match? self.class.delimiters
          split(%r(\s*\-\s*|\s*\/\s*|\s*\:+\s*)).then { |parts| combine parts, :up, "::" }
                                                .then { |text| text.split(/\s*\_\s*|\s+/) }
                                                .then { |parts| combine parts, :up }
        else
          up
        end
      end

      def snakecase
        if match? self.class.delimiters
          split(%r(\s*\-\s*|\s*\/\s*|\s*\:+\s*)).then { |parts| combine parts, :down, "/" }
                                                .then { |txt| txt.split(/(?=[A-Z])|\s*\_\s*|\s+/) }
                                                .then { |parts| combine parts, :down, "_" }
        else
          downcase
        end
      end

      def titleize
        if match? self.class.delimiters
          split(/(?=[A-Z])|\s*\_\s*|\s*\-\s*|\s+/).then { |parts| combine parts, :up, " " }
                                                  .then { |text| text.split %r(\s*\/\s*|\s*\:+\s*) }
                                                  .then { |parts| combine parts, :up, "/" }
        else
          capitalize
        end
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
