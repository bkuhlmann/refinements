# frozen_string_literal: true

module Refinements
  module Structs
    refine Struct do
      def merge **attributes
        dup.merge! attributes
      end

      def merge! **attributes
        to_h.merge(attributes).each { |key, value| self[key] = value }
        self
      end
    end
  end
end
