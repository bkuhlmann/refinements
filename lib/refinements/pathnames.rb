# frozen_string_literal: true

require "pathname"

module Refinements
  module Pathnames
    refine Pathname do
      def rewrite
        read.then { |content| write yield(content) }
      end
    end
  end
end
