# frozen_string_literal: true

require "refinements/arrays"
require "refinements/big_decimals"
require "refinements/hashes"
require "refinements/identity"
require "refinements/strings"

module Refinements
  def self.all
    [
      Refinements::Arrays,
      Refinements::BigDecimals,
      Refinements::Hashes,
      Refinements::Identity,
      Refinements::Strings
    ]
  end
end
