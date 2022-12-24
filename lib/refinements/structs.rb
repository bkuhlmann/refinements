# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Struct primitive.
  module Structs
    refine Struct.singleton_class do
      def with_keywords(**arguments) = keyword_init? ? new(**arguments) : new.merge!(**arguments)

      def with_positions(*values) = keyword_init? ? new(**members.zip(values).to_h) : new(*values)
    end

    refine Struct do
      def merge(...) = dup.merge!(...)

      def merge! object = nil
        to_h.merge!(**object.to_h).each { |key, value| self[key] = value }
        self
      end

      def revalue attributes = each_pair
        return self unless block_given?

        dup.tap { |copy| attributes.each { |key, value| copy[key] = yield self[key], value } }
      end

      def revalue! attributes = each_pair
        return self unless block_given?

        attributes.each { |key, value| self[key] = yield self[key], value }
        self
      end

      def transmute(...) = dup.transmute!(...)

      def transmute! object, **key_map
        mapping = key_map.invert
        merge! object.to_h.slice(*mapping.keys).transform_keys!(mapping)
      end
    end
  end
end
