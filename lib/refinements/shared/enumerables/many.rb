# frozen_string_literal: true

module Refinements
  module Shared
    module Enumerables
      # Provides shared functionality for knowing whether an enumerable has many elements or not.
      module Many
        def many?
          return size > 1 unless block_given?

          total = reduce(0) { |count, item| yield(item) ? count + 1 : count }
          total > 1
        end
      end
    end
  end
end
