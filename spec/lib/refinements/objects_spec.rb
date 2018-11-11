# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Objects do
  using described_class

  # These are contrived examples for simplicity to ensure method calls work.
  describe "#then" do
    subject(:objects) { "one two three" }

    it "responds to single call" do
      result = objects.then(&:capitalize)
      expect(result).to eq("One two three")
    end

    it "reponds to multiple calls" do
      result = objects.then(&:capitalize).then(&:size)
      expect(result).to eq(13)
    end
  end
end
