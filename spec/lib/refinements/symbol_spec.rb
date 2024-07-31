# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Symbol do
  using described_class

  describe "#call" do
    it "passes positionals to receiver" do
      result = %w[clue crow cow].map(&:tr.call("c", "b"))
      expect(result).to eq(%w[blue brow bow])
    end

    it "passes keywords to receiver" do
      result = [1.3, 1.5, 1.9].map(&:round.call(half: :up))
      expect(result).to eq([1, 2, 2])
    end

    it "passes block to receiver" do
      result = [%w[a b c], %w[c a b]].map(&:index.call { |element| element == "b" })
      expect(result).to eq([1, 2])
    end

    it "passes positionals and block to receiver" do
      result = %w[1.outside 2.inside].map(&:sub.call(/\./) { |bullet| bullet + " " })
      expect(result).to eq(["1. outside", "2. inside"])
    end

    it "passes through with no arguments" do
      result = [1, 2, 3].map(&:to_s.call)
      expect(result).to eq(%w[1 2 3])
    end
  end
end
