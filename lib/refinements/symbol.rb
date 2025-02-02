# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Symbol
    refine ::Symbol do
      def call(*positionals, **keywords, &)
        proc { |receiver| receiver.public_send(self, *positionals, **keywords, &) }
      end
    end
  end
end
