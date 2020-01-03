# frozen_string_literal: true

require "pathname"

module Refinements
  module Pathnames
    refine Pathname do
      def name
        basename extname
      end

      def rewrite
        read.then { |content| write yield(content) }
      end
    end
  end
end
