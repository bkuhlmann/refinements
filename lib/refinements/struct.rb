# frozen_string_literal: true

require "refinements/shared/diff"

module Refinements
  # Provides additional enhancements to the Struct primitive.
  module Struct
    refine ::Struct do
      import_methods Shared::Diff

      def merge(...) = dup.merge!(...)

      def merge! object = nil
        to_h.merge!(**object.to_h).each { |key, value| self[key] = value }
        self
      end

      def transmute(...) = dup.transmute!(...)

      def transmute! object, **key_map
        mapping = key_map.invert
        merge! object.to_h.slice(*mapping.keys).transform_keys!(mapping)
      end

      alias_method :with, :merge
    end
  end
end
