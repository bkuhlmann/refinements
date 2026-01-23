# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Symbol primitive.
  module Time
    refine ::Time do
      def rfc_3339 = strftime "%FT%T%:z"
    end
  end
end
