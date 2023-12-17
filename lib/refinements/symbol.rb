# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Symbol
    refine ::Symbol do
      # rubocop:todo Naming/BlockForwarding
      def call(*arguments, &block)
        proc { |receiver| receiver.public_send self, *arguments, &block }
      end
      # rubocop:enable Naming/BlockForwarding
    end
  end
end
