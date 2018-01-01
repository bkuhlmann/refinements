# frozen_string_literal: true

module Refinements
  # Gem identity information.
  module Identity
    def self.name
      "refinements"
    end

    def self.label
      "Refinements"
    end

    def self.version
      "5.0.1"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
