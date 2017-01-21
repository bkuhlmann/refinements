# frozen_string_literal: true

module Refinements
  # Refinements for Strings.
  module Strings
    refine String.singleton_class do
      def delimiters
        %r([a-z][A-Z]|\s*\-\s*|\s*\/\s*|\s*\:+\s*|\s*\_\s*|\s+)
      end
    end

    # rubocop:disable Metrics/BlockLength
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
        if match?(self.class.delimiters)
          result = join_parts split(%r(\s*\-\s*|\s*\/\s*|\s*\:+\s*)), method: :up, delimiter: "::"
          join_parts result.split(/\s*\_\s*|\s+/), method: :up
        else
          up
        end
      end

      def snakecase
        if match?(self.class.delimiters)
          result = join_parts split(%r(\s*\-\s*|\s*\/\s*|\s*\:+\s*)), method: :down, delimiter: "/"
          join_parts result.split(/(?=[A-Z])|\s*\_\s*|\s+/), method: :down, delimiter: "_"
        else
          downcase
        end
      end

      def titleize
        if match?(self.class.delimiters)
          result = join_parts split(/(?=[A-Z])|\s*\_\s*|\s*\-\s*|\s+/), method: :up, delimiter: " "
          join_parts result.split(%r(\s*\/\s*|\s*\:+\s*)), method: :up, delimiter: "/"
        else
          capitalize
        end
      end

      private

      # :reek:DuplicateMethodCall
      # :reek:UtilityFunction
      def join_parts parts, method:, delimiter: ""
        parts.reduce "" do |result, part|
          next part.send(method) if result.empty?
          "#{result}#{delimiter}#{part.send method}"
        end
      end
    end
  end
end
