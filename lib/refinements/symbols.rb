# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Symbols
    refine Symbol do
      def call *arguments, &block
        proc { |receiver| receiver.public_send self, *arguments, &block }
      end
    end
  end
end
