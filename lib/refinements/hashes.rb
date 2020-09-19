# frozen_string_literal: true

module Refinements
  module Hashes
    refine Hash.singleton_class do
      def infinite
        new { |new_hash, missing_key| new_hash[missing_key] = new(&new_hash.default_proc) }
      end

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

      # :reek:TooManyStatements
      def flatten_keys prefix: nil, delimiter: "_", cast: :to_sym
        fail StandardError, "Unknown cast: #{cast}." unless %i[to_sym to_s].include? cast

        reduce({}) do |flat, (key, value)|
          flat_key = prefix ? "#{prefix}#{delimiter}#{key}" : key

          next flat.merge flat_key.public_send(cast) => value unless value.is_a? self.class

          flat.merge(
            recurse { value.flatten_keys prefix: flat_key, delimiter: delimiter, cast: cast }
          )
        end
      end

      def flatten_keys! prefix: nil, delimiter: "_", cast: :to_sym
        replace flatten_keys(prefix: prefix, delimiter: delimiter, cast: cast)
      end

      def symbolize_keys
        reduce({}) { |hash, (key, value)| hash.merge key.to_sym => value }
      end

      def symbolize_keys!
        replace symbolize_keys
      end

      def deep_merge other
        clazz = self.class

        merge other do |_key, this_value, other_value|
          if this_value.is_a?(clazz) && other_value.is_a?(clazz)
            this_value.deep_merge other_value
          else
            other_value
          end
        end
      end

      def deep_merge! other
        replace deep_merge(other)
      end

      def deep_symbolize_keys
        recurse(&:symbolize_keys)
      end

      def deep_symbolize_keys!
        replace deep_symbolize_keys
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
        merge(other) { |_key, old_value, _new_value| old_value }
      end

      def reverse_merge! other
        warn "[DEPRECATION]: #reverse_merge! is deprecated, use #merge! instead."
        replace reverse_merge(other)
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
