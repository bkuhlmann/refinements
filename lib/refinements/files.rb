# frozen_string_literal: true

module Refinements
  module Files
    refine File.singleton_class do
      def rewrite path
        read(path).then { |content| write path, yield(content) }
      end
    end
  end
end
