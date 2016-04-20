# frozen_string_literal: true

module Refinements
  # Refinements for Hashes.
  module HashExtensions
    refine Hash do
      def compact
        dup.compact!
      end

      def compact!
        reject! { |_, value| value.nil? }
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
