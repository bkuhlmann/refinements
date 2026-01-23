# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::DateTime do
  using described_class

  describe ".utc" do
    it "prints deprecation warning" do
      expectation = proc { DateTime.utc }
      message = "`DateTime.utc` is deprecated, use `Time` instead.\n"

      expect(&expectation).to output(message).to_stderr
    end

    it "answers UTC date and time" do
      expect(DateTime.utc.to_s).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+00:00/)
    end
  end
end
