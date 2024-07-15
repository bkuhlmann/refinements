# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Object class.
  module Object
    refine ::Object do
      def in? other
        case other
          when Range then other.cover? self
          when ::Array, Enumerable, ::Hash, Set, ::String then other.include? self
          else fail NoMethodError, "`#{self.class}#include?` must be implemented."
        end
      end

      def to_proc
        return method(:call).to_proc if respond_to? :call

        fail NoMethodError, "`#{self.class}#call` must be implemented."
      end
    end
  end
end
