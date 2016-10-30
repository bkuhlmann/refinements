# frozen_string_literal: true

module Refinements
  # Refinements for Strings.
  module StringExtensions
    refine String.singleton_class do
      def delimiters
        %r([a-z][A-Z]|\s*\-\s*|\s*\/\s*|\s*\:+\s*|\s*\_\s*|\s+)
      end
    end

    # rubocop:disable Metrics/BlockLength
    refine String do
      def blank?
        !match(/\A\s*\z/).nil?
      end

      def up
        return self if empty?
        self[0].upcase + self[1, size]
      end

      def down
        return self if empty?
        self[0].downcase + self[1, size]
      end

      def camelcase
        if self =~ self.class.delimiters
          result = up_and_join split(%r(\s*\-\s*|\s*\/\s*|\s*\:+\s*)), delimiter: "::"
          up_and_join result.split(/\s*\_\s*|\s+/)
        else
          up
        end
      end

      def snakecase
        if self =~ self.class.delimiters
          result = down_and_join split(%r(\s*\-\s*|\s*\/\s*|\s*\:+\s*)), delimiter: "/"
          down_and_join result.split(/(?=[A-Z])|\s*\_\s*|\s+/), delimiter: "_"
        else
          downcase
        end
      end

      def titleize
        if self =~ self.class.delimiters
          result = capitalize_and_join split(%r(\s*\/\s*|\s*\:+\s*)), delimiter: "/"
          up_and_join result.split(/\s*\_\s*|\s*\-\s*|\s+/), delimiter: " "
        else
          capitalize
        end
      end

      private

      def up_and_join parts, delimiter: ""
        parts.reduce "" do |result, part|
          next part.up if result.empty?
          "#{result}#{delimiter}#{part.up}"
        end
      end

      def down_and_join parts, delimiter: ""
        parts.reduce "" do |result, part|
          next part.down if result.empty?
          "#{result}#{delimiter}#{part.down}"
        end
      end

      def capitalize_and_join parts, delimiter: ""
        parts.reduce "" do |result, part|
          next part.capitalize if result.empty?
          "#{result}#{delimiter}#{part.capitalize}"
        end
      end
    end
  end
end
