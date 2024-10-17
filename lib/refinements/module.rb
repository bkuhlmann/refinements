# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Module
    refine ::Module do
      def pseudonym prefix, suffix = object_id, delimiter: "-"
        set_temporary_name "#{prefix}#{delimiter}#{suffix}"
      end
    end
  end
end
