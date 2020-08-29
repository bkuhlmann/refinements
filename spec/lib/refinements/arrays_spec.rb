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

  describe "#include" do
    let(:array) { [1, 2, 3] }

    it "answers array which includes additional array" do
      expect(array.include([4, 5, 6])).to eq([1, 2, 3, 4, 5, 6])
    end

    it "answers array which includes additional elements" do
      expect(array.include(4, 5)).to eq([1, 2, 3, 4, 5])
    end

    it "answers array which includes additional array and elements" do
      expect(array.include(4, 5, [6, 7])).to eq([1, 2, 3, 4, 5, 6, 7])
    end

    it "answers array which includes out-of-order elements" do
      expect(array.include(0, 6)).to eq([1, 2, 3, 0, 6])
    end

    it "answers array which includes duplicate elements" do
      expect(array.include(1)).to eq([1, 2, 3, 1])
    end

    it "answers array when given no arguments" do
      expect(array.include).to eq(array)
    end

    it "duplicates array" do
      expect(array.include).not_to equal(array)
    end
  end

  describe "#exclude" do
    let(:array) { [1, 2, 3, 4, 5] }

    it "answers array which exludes additional array" do
      expect(array.exclude([3, 4, 5])).to eq([1, 2])
    end

    it "answers array which exludes additional elements" do
      expect(array.exclude(4, 5)).to eq([1, 2, 3])
    end

    it "answers array which excludes additional array and elements" do
      expect(array.exclude(1, 2, [4, 5])).to eq([3])
    end

    it "answers array which exludes out-of-order elements" do
      expect(array.exclude(1, 3, 5)).to eq([2, 4])
    end

    it "answers array which excludes duplicate elements" do
      expect(array.exclude(1, 1)).to eq([2, 3, 4, 5])
    end

    it "answers array when given no arguments" do
      expect(array.exclude).to eq(array)
    end

    it "duplicates array" do
      expect(array.exclude).not_to equal(array)
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
