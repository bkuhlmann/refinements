# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Symbol
    refine ::Symbol do
      def call(*positionals, **keywords, &block)
        proc { |receiver| receiver.public_send self, *positionals, **keywords, &block }
      end
    end
  end
end
