# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Binding do
  using described_class

  describe "#[]" do
    it "answers value for local variable" do
      a = 1
      expect(binding[:a]).to eq(1)
    end

    it "fails when local variable doesn't exist" do
      expectation = proc { binding[:bogus] }
      expect(&expectation).to raise_error(NameError, /local variable 'bogus' is not defined/)
    end
  end

  describe "#[]=" do
    it "sets value for existing local variable" do
      a = 1
      binding[:a] = 5

      expect(binding[:a]).to eq(5)
    end

    it "ignores value for local variable that doesn't exist" do
      binding[:bogus] = "bad"
      expectation = proc { binding[:bogus] }

      expect(&expectation).to raise_error(NameError, /local variable 'bogus' is not defined/)
    end
  end

  describe "#local?" do
    it "answers true when defined" do
      a = 1
      expect(binding.local?(:a)).to be(true)
    end

    it "answers false when not defined" do
      expect(binding.local?(:a)).to be(false)
    end
  end

  describe "#locals" do
    it "answers local variables when they exist" do
      a = 1
      b = 2

      expect(binding.locals).to eq(%i[a b])
    end

    it "answers empty array when no variables exist" do
      expect(binding.locals).to eq([])
    end
  end
end
