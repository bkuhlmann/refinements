# frozen_string_literal: true

require "stringio"
require "refinements/shared/ios/reread"

module Refinements
  # Provides additional enhancements to the StringIO primitive.
  module StringIOs
    refine StringIO do
      import_methods Shared::IOs::Reread
    end
  end
end
