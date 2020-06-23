# frozen_string_literal: true

module Refinements
  module Hashes
    refine Hash.singleton_class do
      def with_default value
        new { |new_hash, missing_key| new_hash[missing_key] = value }
      end
    end

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

      def deep_merge! other
        clazz = self.class

        merge! other do |_key, this_value, other_value|
          if this_value.is_a?(clazz) && other_value.is_a?(clazz)
            this_value.deep_merge other_value
          else
            other_value
          end
        end
      end

      def deep_symbolize_keys
        recurse(&:symbolize_keys)
      end

      def deep_symbolize_keys!
        recurse(&:symbolize_keys!)
      end

      def recurse &block
        return self unless block_given?

        transform = yield self

        transform.each do |key, value|
          transform[key] = value.recurse(&block) if value.is_a? self.class
        end
      end

      def rekey mapping = {}
        return self if mapping.empty?

        transform_keys { |key| mapping[key] || key }
      end

      def rekey! mapping = {}
        replace rekey(mapping)
      end

      def reverse_merge other
        warn "[DEPRECATION]: #reverse_merge is deprecated, use #merge instead."
        other.merge self
      end

      def reverse_merge! other
        warn "[DEPRECATION]: #reverse_merge! is deprecated, use #merge! instead."
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
