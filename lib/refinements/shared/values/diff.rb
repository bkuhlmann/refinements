# frozen_string_literal: true

module Refinements
  module Shared
    module Values
      # Provides shared whole value functionality for knowing the difference between two objects.
      module Diff
        def diff other
          if other.is_a? self.class
            to_h.merge(other.to_h) { |_, one, two| [one, two].uniq }
                .select { |_, diff| diff.size == 2 }
          else
            to_h.each.with_object({}) { |(key, value), diff| diff[key] = [value, nil] }
          end
        end
      end
    end
  end
end
