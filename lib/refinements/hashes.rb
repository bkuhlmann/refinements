# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Hash primitive.
  module Hashes
    refine Hash.singleton_class do
      def infinite
        new { |new_hash, missing_key| new_hash[missing_key] = new(&new_hash.default_proc) }
      end

      def with_default(value) = new { |new_hash, missing_key| new_hash[missing_key] = value }
    end

    refine Hash do
      def compress = dup.compress!

      def compress!
        return self if empty?

        compact!.delete_if { |_key, value| value.respond_to?(:empty?) && value.empty? }
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

      def deep_merge!(other) = replace(deep_merge(other))

      def deep_stringify_keys = recurse(&:stringify_keys)

      def deep_stringify_keys! = replace(deep_stringify_keys)

      def deep_symbolize_keys = recurse(&:symbolize_keys)

      def deep_symbolize_keys! = replace(deep_symbolize_keys)

      def fetch_value(key, *default_value, &)
        fetch(key, *default_value, &) || default_value.first
      end

      # :reek:TooManyStatements
      def flatten_keys prefix: nil, delimiter: "_", cast: :to_sym
        fail StandardError, "Unknown cast: #{cast}." unless %i[to_sym to_s].include? cast

        reduce({}) do |flat, (key, value)|
          flat_key = prefix ? "#{prefix}#{delimiter}#{key}" : key

          next flat.merge flat_key.public_send(cast) => value unless value.is_a? self.class

          flat.merge(
            recurse { value.flatten_keys prefix: flat_key, delimiter:, cast: }
          )
        end
      end

      def flatten_keys! prefix: nil, delimiter: "_", cast: :to_sym
        replace flatten_keys(prefix:, delimiter:, cast:)
      end

      def recurse &block
        return self unless block

        transform = yield self

        transform.each do |key, value|
          transform[key] = value.recurse(&block) if value.is_a? self.class
        end
      end

      def stringify_keys = transform_keys(&:to_s)

      def stringify_keys! = transform_keys!(&:to_s)

      def symbolize_keys = transform_keys(&:to_sym)

      def symbolize_keys! = transform_keys!(&:to_sym)

      def use &block
        return [] unless block

        block.parameters
             .map { |(_type, key)| self[key] }
             .then { |values| yield values }
      end
    end
  end
end
