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
      "2.0.0"
    end

    def self.label_version
      "#{label} #{version}"
    end
  end
end
