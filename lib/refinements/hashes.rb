# frozen_string_literal: true

module Refinements
  # Refinements for Hashes.
  module Hashes
    # rubocop:disable Metrics/BlockLength
    refine Hash do
      def symbolize_keys
        dup.symbolize_keys!
      end

      def symbolize_keys!
        keys.each { |key| self[key.to_sym] = delete(key) }
        self
      end

      def slice *keys
        keys.each.with_object({}) do |key, sliced_hash|
          sliced_hash[key] = self[key] if key?(key)
        end
      end

      def slice! *keys
        replace slice(*keys)
      end

      def deep_merge other_hash
        dup.deep_merge! other_hash
      end

      def deep_merge! other_hash
        other_hash.each.with_object self do |(other_key, other_value), original_hash|
          current_value = original_hash[other_key]
          original_hash[other_key] = deep_merge_value current_value, other_value
        end
      end

      def reverse_merge other_hash
        other_hash.merge self
      end

      def reverse_merge! other_hash
        merge!(other_hash) { |_, left_value, _| left_value }
      end

      private

      def deep_merge_value current_value, other_value
        return current_value.deep_merge(other_value) if current_value.is_a?(Hash) && other_value.is_a?(Hash)
        other_value
      end
    end
  end
end
