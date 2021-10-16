# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to Class objects.
  module Classes
    refine Class do
      def descendants
        ObjectSpace.each_object(singleton_class)
                   .reject { |klass| klass.singleton_class? || klass == self }
      end
    end
  end
end
