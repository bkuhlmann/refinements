# frozen_string_literal: true

module Refinements
  # Refinements for Strings.
  module StringExtensions
    refine String do
      def camelcase
        return self if self =~ /\A[a-zA-Z]{1,}\z/ && self !~ /\A[A-Z]{1,}\z/
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
