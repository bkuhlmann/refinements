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

      def revalue attributes = each_pair
        return self unless block_given?

        dup.tap do |copy|
          attributes.each { |key, value| copy[key] = yield self[key], value }
        end
      end

      def revalue! attributes = each_pair
        return self unless block_given?

        attributes.each { |key, value| self[key] = yield self[key], value }
        self
      end
    end
  end
end
