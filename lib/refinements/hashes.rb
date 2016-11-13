# frozen_string_literal: true

module Refinements
  # Refinements for Hashes.
  module Hashes
    # rubocop:disable Metrics/BlockLength
    refine Hash do
      # TODO: Remove when Ruby 2.4 is released.
      def compact
        puts "[DEPRECATION]: #compact is deprecated and is included, by default, in Ruby 2.4."
        dup.compact!
      end

      # TODO: Remove when Ruby 2.4 is released.
      def compact!
        puts "[DEPRECATION]: #compact! is deprecated and is included, by default, in Ruby 2.4."
        reject! { |_, value| value.nil? }
      end

      def symbolize_keys
        dup.symbolize_keys!
      end

      def symbolize_keys!
        keys.each { |key| self[key.to_sym] = delete(key) }
        self
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
