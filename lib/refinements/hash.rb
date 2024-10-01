# frozen_string_literal: true

require "refinements/shared/many"

module Refinements
  # Provides additional enhancements to the Hash primitive.
  module Hash
    refine ::Hash.singleton_class do
      def infinite = new { |nascence, lacuna| nascence[lacuna] = new(&nascence.default_proc) }

      def with_default(value) = new { |nascence, lacuna| nascence[lacuna] = value }
    end

    refine ::Hash do
      import_methods Shared::Many

      def compress = compact.delete_if { |_key, value| value.respond_to?(:empty?) && value.empty? }

      def compress!
        delete_if { |_key, value| value.respond_to?(:empty?) && value.empty? }
        compact!
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

      def diff other
        return differences_from other if other.is_a?(self.class) && keys.sort! == other.keys.sort!

        each.with_object({}) { |(key, value), diff| diff[key] = [value, nil] }
      end

      def fetch_value(key, *default, &)
        fetch(key, *default, &) || (yield if block_given?) || default.first
      end

      def flatten_keys prefix: nil, delimiter: "_"
        reduce({}) do |accumulator, (key, value)|
          flat_key = prefix ? :"#{prefix}#{delimiter}#{key}" : key

          next accumulator.merge flat_key => value unless value.is_a? ::Hash

          accumulator.merge(recurse { value.flatten_keys prefix: flat_key, delimiter: })
        end
      end

      def flatten_keys!(prefix: nil, delimiter: "_") = replace flatten_keys(prefix:, delimiter:)

      def recurse &block
        return self unless block

        transform = yield self
        transform.each { |key, value| transform[key] = value.recurse(&block) if value.is_a? ::Hash }
      end

      def stringify_keys = transform_keys(&:to_s)

      def stringify_keys! = transform_keys!(&:to_s)

      def symbolize_keys = transform_keys(&:to_sym)

      def symbolize_keys! = transform_keys!(&:to_sym)

      def transform_value(key, &) = dup.transform_value!(key, &)

      def transform_value! key
        block_given? && key?(key) ? merge!(key => yield(self[key])) : self
      end

      def transform_with(**) = dup.transform_with!(**)

      def transform_with!(**mutations)
        mutations.each { |key, function| transform_value! key, &function }
        self
      end

      def use &block
        return [] unless block

        block.parameters
             .map { |(_type, key)| self[key] || self[key.to_s] }
             .then { |values| yield values }
      end

      private

      def differences_from other
        result = merge(other.to_h) { |_, one, two| [one, two].uniq }
        result.select { |_, diff| diff.size == 2 }
      end
    end
  end
end
