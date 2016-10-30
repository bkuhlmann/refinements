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

      def cap
        return self if empty?
        self[0].upcase + self[1, size]
      end

      def down
        return self if empty?
        self[0].downcase + self[1, size]
      end

      def camelcase
        if self =~ self.class.delimiters
          result = cap_and_join split(%r(\s*\-\s*|\s*\/\s*|\s*\:+\s*)), delimiter: "::"
          cap_and_join result.split(/\s*\_\s*|\s+/)
        else
          cap
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
          result = transform_and_join split(%r(\s*\/\s*|\s*\:+\s*)),
                                      method: :capitalize,
                                      delimiter: "/"
          cap_and_join result.split(/\s*\_\s*|\s*\-\s*|\s+/), delimiter: " "
        else
          capitalize
        end
      end

      private

      # Can't be replaced by #transform_and_join due to dynamic method dispatch limitations with
      # refinements.
      def cap_and_join items, delimiter: ""
        items.reduce "" do |result, item|
          next item.cap if result.empty?
          "#{result}#{delimiter}#{item.cap}"
        end
      end

      # Can't be replaced by #transform_and_join due to dynamic method dispatch limitations with
      # refinements.
      def down_and_join items, delimiter: ""
        items.reduce "" do |result, item|
          next item.down if result.empty?
          "#{result}#{delimiter}#{item.down}"
        end
      end

      def transform_and_join parts, method:, delimiter: ""
        parts.reduce "" do |result, part|
          next part.public_send(method) if result.empty?
          "#{result}#{delimiter}#{part.public_send method}"
        end
      end
    end
  end
end
