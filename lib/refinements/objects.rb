# frozen_string_literal: true

module Refinements
  # Refinements for objects.
  module Objects
    refine Object do
      alias_method :then, :yield_self
    end
  end
end
