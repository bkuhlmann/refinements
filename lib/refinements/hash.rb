# frozen_string_literal: true

require "refinements/shared/many"

module Refinements
  # Provides additional enhancements to the Hash primitive.
  # rubocop:todo-next Metrics/ModuleLength
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

      def deep_merge(other, &) = dup.deep_merge!(other, &)

      def deep_merge!(other, &)
        klass = self.class

        merge! other do |key, first, second|
          if first.is_a?(klass) && second.is_a?(klass) then first.deep_merge(second, &)
          elsif first.is_a?(::Array) && second.is_a?(::Array) then deep_concat(first, second, &)
          elsif block_given? then yield key, first, second
          else second
          end
        end
      end

      def deep_stringify_keys = recurse(&:stringify_keys)

      def deep_stringify_keys! = replace(deep_stringify_keys)

      def deep_symbolize_keys = recurse(&:symbolize_keys)

      def deep_symbolize_keys! = replace(deep_symbolize_keys)

      def diff other
        return diff_array other if other.is_a?(self.class) && keys.sort! == other.keys.sort!

        each.with_object({}) { |(key, value), diff| diff[key] = [value, nil] }
      end

      def expand_keys delimiter: "."
        each.with_object({}) do |(key, value), all|
          parts = String(key).split(delimiter).reverse
          all.deep_merge! parts.reduce(value) { |accumulator, part| {part => accumulator} }
        end
      end

      def fetch_deep(*keys, default: NilClass, &)
        keys.reduce fallback(keys.shift, default, &) do |value, key|
          unless value.is_a?(::Hash) || (value.is_a?(::Array) && key.is_a?(::Integer))
            fail KeyError, "Unable to find #{key.inspect} in #{value.inspect}."
          end

          default == NilClass ? value.fetch(key, &) : value.fetch(key, default)
        end
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

      def transform_with! **operations
        operations.each { |key, function| self[key] = function.call self[key] if key? key }
        self
      end

      def use &block
        warn "`#{self.class}##{__method__}` is deprecated and will be removed " \
             "in the next major version.",
             category: :deprecated

        return [] unless block

        block.parameters
             .map { |(_type, key)| self[key] || self[key.to_s] }
             .then { |values| yield values }
      end

      private

      def deep_concat(original, second, &)
        first = original.dup
        klass = self.class

        second.each.with_index do |second_item, index|
          first_item = first[index]

          if first_item.is_a?(klass) && second_item.is_a?(klass)
            first[index] = first_item.deep_merge!(second_item, &)
          elsif second_item.is_a? ::Array
            first[index] = deep_concat(first_item, second_item, &)
          else
            first.append(second_item).uniq!
          end
        end

        first
      end

      def diff_array other
        merged = merge(other.to_h) { |_, one, two| [one, two].uniq }
        merged.select { |_, diff| diff.size == 2 }
      end

      def fallback(key, default, &)
        default == NilClass ? fetch(key, &) : fetch(key, default)
      end
    end
  end
end
