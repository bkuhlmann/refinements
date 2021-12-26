# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Symbols
    refine Symbol do
      # rubocop:disable Style/MethodDefParentheses
      def call(*arguments, &)
        proc { |receiver| receiver.public_send self, *arguments, & }
      end
      # rubocop:enable Style/MethodDefParentheses
    end
  end
end
