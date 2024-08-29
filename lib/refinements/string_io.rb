# frozen_string_literal: true

require "refinements/shared/reread"
require "stringio"

module Refinements
  # Provides additional enhancements to the StringIO primitive.
  module StringIO
    refine ::StringIO do
      import_methods Shared::Reread

      alias_method :to_s, :string
      alias_method :to_str, :string
    end
  end
end
