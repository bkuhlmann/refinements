# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Symbols do
  using described_class

  describe "#call" do
    it "passes arguments to receiver" do
      result = %w[clue crow cow].map(&:tr.call("c", "b"))
      expect(result).to eq(%w[blue brow bow])
    end

    it "passes block to receiver" do
      result = [%w[a b c], %w[c a b]].map(&:index.call { |element| element == "b" })
      expect(result).to eq([1, 2])
    end

    it "passes arguments and block to receiver" do
      result = %w[1.outside 2.inside].map(&:sub.call(/\./) { |bullet| bullet + " " })
      expect(result).to eq(["1. outside", "2. inside"])
    end

    it "passes through with no arguments or block" do
      result = [1, 2, 3].map(&:to_s.call)
      expect(result).to eq(%w[1 2 3])
    end
  end
end
