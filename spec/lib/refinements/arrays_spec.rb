# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Arrays do
  using described_class

  describe "#compress" do
    it "answers original array when nothing to do" do
      arrays = %w[one two]
      expect(arrays.compress).to contain_exactly("one", "two")
    end

    it "answers array with nils removed" do
      arrays = ["one", nil, "two"]
      expect(arrays.compress).to contain_exactly("one", "two")
    end

    it "answers array with blank strings removed" do
      arrays = ["one", "", "two"]
      expect(arrays.compress).to contain_exactly("one", "two")
    end

    it "does not modify original values" do
      arrays = ["one", nil, "", "two"]
      arrays.compress

      expect(arrays).to contain_exactly("one", nil, "", "two")
    end
  end

  describe "#compress!" do
    it "answers original array when nothing to do" do
      arrays = %w[one two]
      expect(arrays.compress!).to contain_exactly("one", "two")
    end

    it "answers array with nils removed" do
      arrays = ["one", nil, "two"]
      expect(arrays.compress!).to contain_exactly("one", "two")
    end

    it "answers array with empty values removed" do
      arrays = ["one", "", "two"]
      expect(arrays.compress!).to contain_exactly("one", "two")
    end

    it "modifies original values" do
      arrays = ["one", nil, "", "two"]
      arrays.compress!

      expect(arrays).to contain_exactly("one", "two")
    end
  end

  describe "#ring" do
    it "answers slices without block" do
      expect([1, 2, 3].ring).to contain_exactly(
        [1, 2, 3],
        [2, 3, 1],
        [3, 1, 2]
      )
    end

    it "yields slices when given block" do
      expectation = []
      [1, 2, 3].ring { |slice| expectation.append slice }

      expect(expectation).to contain_exactly(
        [1, 2, 3],
        [2, 3, 1],
        [3, 1, 2]
      )
    end
  end
end
