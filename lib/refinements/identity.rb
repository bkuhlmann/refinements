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
      "0.1.0"
    end

    def self.label_version
      [label, version].join " "
    end
  end
end
