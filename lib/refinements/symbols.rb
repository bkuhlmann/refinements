# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Symbols
    refine Symbol do
      def call(*arguments, &)
        proc { |receiver| receiver.public_send self, *arguments, & }
      end
    end
  end
end
