# frozen_string_literal: true

module Refinements
  # Refinements for Strings.
  module StringExtensions
    refine String do
      def cap
        return self if empty?
        self[0].upcase + self[1, size]
      end

      def camelcase
        return self if self =~ /\A\w+\z/ && self =~ /[A-Z]/ && self =~ /[a-z]/
        snakecase.split("_").map(&:capitalize).join ""
      end

      def snakecase
        downcase.gsub(/[^a-z]/, "_").squeeze "_"
      end

      def titleize
        snakecase.split("_").map(&:capitalize).join " "
      end
    end
  end
end
