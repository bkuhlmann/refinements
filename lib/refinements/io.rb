# frozen_string_literal: true

require "refinements/shared/reread"

module Refinements
  # Provides additional enhancements to the IO primitive.
  module IO
    refine ::IO.singleton_class do
      def void
        new(sysopen("/dev/null", "w+")).then do |io|
          return io unless block_given?

          yield io
          io.tap(&:close)
        end
      end
    end

    refine ::IO do
      import_methods Shared::Reread

      def redirect other
        return self unless block_given?

        backup = dup
        reopen other
        yield self
        reopen backup
      end

      def squelch(&block) = self.class.void.then { |void| redirect(void, &block) }
    end
  end
end
