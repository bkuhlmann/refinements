# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Classes do
  using described_class

  describe "#descendants" do
    it "answers descendants" do
      a = Class.new
      b = Class.new a
      c = Class.new a

      expect(a.descendants).to contain_exactly(b, c)
    end

    it "answers empty array with no descendants" do
      a = Class.new
      expect(a.descendants).to eq([])
    end
  end
end
