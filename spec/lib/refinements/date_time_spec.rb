# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::DateTime do
  using described_class

  describe ".utc" do
    it "answers UTC date and time" do
      expect(DateTime.utc.to_s).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+00:00/)
    end
  end
end
