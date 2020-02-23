# frozen_string_literal: true

module Refinements
  module Hashes
    refine Hash do
      def except *keys
        reject { |key, _value| keys.include? key }
      end

      def except! *keys
        replace except(*keys)
      end

      def symbolize_keys
        reduce({}) { |hash, (key, value)| hash.merge key.to_sym => value }
      end

      def symbolize_keys!
        replace symbolize_keys
      end

      def deep_merge other
        dup.deep_merge! other
      end

      # :reek:FeatureEnvy
      def deep_merge! other
        merge! other do |_key, this_value, other_value|
          if this_value.is_a?(Hash) && other_value.is_a?(Hash)
            this_value.deep_merge other_value
          else
            other_value
          end
        end
      end

      def reverse_merge other
        other.merge self
      end

      def reverse_merge! other
        merge!(other) { |_key, old_value, _new_value| old_value }
      end

      def use &block
        return [] unless block_given?

        block.parameters
             .map { |(_type, key)| self[key] }
             .then { |values| yield values }
      end
    end
  end
end
