# frozen_string_literal: true

module Refinements
  # Provides additional enhancements to the Binding class.
  module Binding
    refine ::Binding do
      alias_method :[], :local_variable_get
      alias_method :[]=, :local_variable_set
      alias_method :local?, :local_variable_defined?
      alias_method :locals, :local_variables
    end
  end
end
