# frozen_string_literal: true

require "refinements/shared/diff"

module Refinements
  # Provides additional enhancements to the Struct primitive.
  module Data
    refine ::Data do
      import_methods Shared::Diff
    end
  end
end
