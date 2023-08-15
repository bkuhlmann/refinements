# frozen_string_literal: true

require "refinements/shared/values/diff"

module Refinements
  # Provides additional enhancements to the Struct primitive.
  module Data
    refine ::Data do
      import_methods Shared::Values::Diff
    end
  end
end
