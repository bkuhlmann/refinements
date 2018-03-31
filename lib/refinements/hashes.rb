# frozen_string_literal: true

module Refinements
  # Refinements for Hashes.
  module Hashes
    # rubocop:disable Metrics/BlockLength
    refine Hash do
      def except *keys
        reject { |key, _value| keys.include? key }
      end

      def except! *keys
        replace except(*keys)
      end

      def symbolize_keys
        dup.symbolize_keys!
      end

      def symbolize_keys!
        keys.each { |key| self[key.to_sym] = delete key }
        self
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

        values = block.parameters.map { |(_type, key)| self[key] }
        yield values
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
