# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Array do
  using described_class

  describe "combinatorial?" do
    subject(:array) { %w[a b c] }

    it "answers true when sorted" do
      expect(array.combinatorial?(%w[a b c])).to be(true)
    end

    it "answers true when unsorted" do
      expect(array.combinatorial?(%w[c a b])).to be(true)
    end

    it "answers true with one identical element" do
      expect(array.combinatorial?(%w[c])).to be(true)
    end

    it "answers true with multiple identical elements" do
      expect(array.combinatorial?(%w[c b])).to be(true)
    end

    it "answers false with one different element" do
      expect(array.combinatorial?(%w[x])).to be(false)
    end

    it "answers false with identical and different elements" do
      expect(array.combinatorial?(%w[z b c])).to be(false)
    end

    it "answers false with identical and extra elements" do
      expect(array.combinatorial?(%w[a b c d])).to be(false)
    end

    it "answers false with an empty array" do
      expect(array.combinatorial?([])).to be(false)
    end
  end

  describe "#compress" do
    subject(:array) { [1, "blueberry", nil, "", [], {}, object] }

    let(:object) { Object.new }

    it "answers array with nils and empty objects removed" do
      expect(array.compress).to eq([1, "blueberry", object])
    end

    it "answers itself with nothing to remove" do
      slice = array.slice(0, 2).compress
      expect(slice).to contain_exactly(1, "blueberry")
    end

    it "answers itself when empty" do
      expect([].compress).to eq([])
    end

    it "doesn't mutate itself" do
      array.compress
      expect(array).to eq([1, "blueberry", nil, "", [], {}, object])
    end
  end

  describe "#compress!" do
    subject(:array) { [1, "blueberry", nil, "", [], {}, object] }

    let(:object) { Object.new }

    it "answers array with nils and empty objects removed" do
      expect(array.compress!).to eq([1, "blueberry", object])
    end

    it "answers nil with nothing to remove" do
      slice = array.slice(0, 2).compress!
      expect(slice).to be(nil)
    end

    it "answers nil when empty" do
      expect([].compress!).to be(nil)
    end

    it "mutates itself" do
      array.compress!
      expect(array).to eq([1, "blueberry", object])
    end
  end

  describe "#excluding" do
    subject(:array) { [1, 2, 3, 4, 5] }

    it "answers array which exludes additional array" do
      expect(array.excluding([3, 4, 5])).to eq([1, 2])
    end

    it "answers array which exludes additional elements" do
      expect(array.excluding(4, 5)).to eq([1, 2, 3])
    end

    it "answers array which excludes additional array and elements" do
      expect(array.excluding(1, 2, [4, 5])).to eq([3])
    end

    it "answers array which exludes out-of-order elements" do
      expect(array.excluding(1, 3, 5)).to eq([2, 4])
    end

    it "answers array which excludes duplicate elements" do
      expect(array.excluding(1, 1)).to eq([2, 3, 4, 5])
    end

    it "answers array when given no arguments" do
      expect(array.excluding).to eq(array)
    end

    it "duplicates array" do
      expect(array.excluding).not_to equal(array)
    end
  end

  describe "#including" do
    subject(:array) { [1, 2, 3] }

    it "answers array which includes additional array" do
      expect(array.including([4, 5, 6])).to eq([1, 2, 3, 4, 5, 6])
    end

    it "answers array which includes additional elements" do
      expect(array.including(4, 5)).to eq([1, 2, 3, 4, 5])
    end

    it "answers array which includes additional array and elements" do
      expect(array.including(4, 5, [6, 7])).to eq([1, 2, 3, 4, 5, 6, 7])
    end

    it "answers array which includes out-of-order elements" do
      expect(array.including(0, 6)).to eq([1, 2, 3, 0, 6])
    end

    it "answers array which includes duplicate elements" do
      expect(array.including(1)).to eq([1, 2, 3, 1])
    end

    it "answers array when given no arguments" do
      expect(array.including).to eq(array)
    end

    it "duplicates array" do
      expect(array.including).not_to equal(array)
    end
  end

  describe "#intersperse" do
    subject(:array) { [1, 2, 3] }

    it "answers original array with no arguments" do
      expect(array.intersperse).to eq([1, 2, 3])
    end

    it "answers array with single element interspersed" do
      expect(array.intersperse(:a)).to eq([1, :a, 2, :a, 3])
    end

    it "answers array with multiple elements interspersed" do
      expect(array.intersperse(:a, :b)).to eq([1, :a, :b, 2, :a, :b, 3])
    end

    it "answers array with other array interspersed" do
      expect(array.intersperse(%i[a b])).to eq([1, :a, :b, 2, :a, :b, 3])
    end
  end

  describe "#many?" do
    it "answers true with more than one element without a block" do
      expect([1, 2].many?).to be(true)
    end

    it "answers true with more than one element with a block" do
      expect([1, 2, 3].many?(&:odd?)).to be(true)
    end

    it "answers false with one element only" do
      expect([1].many?).to be(false)
    end

    it "answers false when empty" do
      expect([].many?).to be(false)
    end
  end

  describe "#maximum" do
    let(:model) { Data.define :x }

    it "answers maximum extracted value" do
      records = [model[x: 3], model[x: 1], model[x: 2]]
      expect(records.maximum(:x)).to eq(3)
    end

    it "answers nil when empty" do
      expect([].maximum(:x)).to be(nil)
    end

    it "fails when sending invalid message to elements" do
      expectation = proc { [1, 2].maximum :bogus }
      expect(&expectation).to raise_error(NoMethodError, /bogus/)
    end
  end

  describe "#mean" do
    it "answers zero with empty array" do
      expect([].mean).to eq(0.0)
    end

    it "answers zero with zero element only" do
      expect([0].mean).to eq(0.0)
    end

    it "answers value for single element array" do
      expect([5].mean).to eq(5.0)
    end

    it "answers decimal precision with integer tuple" do
      expect([1, 2].mean).to eq(1.5)
    end

    it "answers decimal precision with decimals" do
      expect([1.25, 1.5, 2.5].mean).to eq(1.75)
    end

    it "answers decimal precision with integers" do
      expect([1, 2, 3].mean).to eq(2.0)
    end
  end

  describe "#minimum" do
    let(:model) { Data.define :x }

    it "answers minimum extracted value" do
      records = [model[x: 3], model[x: 1], model[x: 2]]
      expect(records.minimum(:x)).to eq(1)
    end

    it "answers nil when empty" do
      expect([].minimum(:x)).to be(nil)
    end

    it "fails when sending invalid message to elements" do
      expectation = proc { [1, 2].minimum :bogus }
      expect(&expectation).to raise_error(NoMethodError, /bogus/)
    end
  end

  describe "#pad" do
    it "answers same, single element, array with default maximum" do
      expect([1].pad(0)).to eq([1])
    end

    it "answers same, multi-element, array with default maximum" do
      expect([1, 2, 3].pad(0)).to eq([1, 2, 3])
    end

    it "answers same array with smaller maximum" do
      expect([1, 2].pad(0, 1)).to eq([1, 2])
    end

    it "answers padded array with larger maximum" do
      expect([1, 2].pad(0, 3)).to eq([1, 2, 0])
    end

    it "answers same array with negative maximum" do
      expect([1, 2].pad(0, -1)).to eq([1, 2])
    end

    it "doesn't mutate itself" do
      array = [1, 2]
      array.pad 0, 5

      expect(array).to eq([1, 2])
    end
  end

  describe "#pick" do
    subject(:array) { [{name: "a", label: "A"}, {name: "b", label: "B"}, {name: "c", label: "C"}] }

    it "answers value for first element key" do
      expect(array.pick(:name)).to eq("a")
    end

    it "answers values (array) first element keys" do
      expect(array.pick(:name, :label)).to eq(%w[a A])
    end

    it "answers nil when not given keys" do
      expect(array.pick).to be(nil)
    end

    it "answers nil when empty" do
      expect([].pick(:test)).to be(nil)
    end
  end

  describe "#pluck" do
    subject(:array) { [{name: "a", label: "A"}, {name: "b", label: "B"}, {name: "c", label: "C"}] }

    it "answers array of values for matching key" do
      expect(array.pluck(:name)).to eq(%w[a b c])
    end

    it "answers nested array of values for matching keys" do
      expect(array.pluck(:name, :label)).to eq([%w[a A], %w[b B], %w[c C]])
    end

    it "answers empty array when not given keys" do
      expect(array.pluck).to eq([])
    end

    it "answers empty array when already empty" do
      expect([].pluck(:test)).to eq([])
    end

    it "answers duplicate when empty" do
      array = []
      expect(array.pluck).not_to equal(array)
    end
  end

  describe "#replace_at" do
    subject(:array) { %i[a b c] }

    it "replaces with element at start of array" do
      array.replace_at 0, :x
      expect(array).to eq(%i[x b c])
    end

    it "replaces with a single element at specific index" do
      array.replace_at 1, :x
      expect(array).to eq(%i[a x c])
    end

    it "replaces with multiple element at specific index" do
      array.replace_at 1, :x, :y
      expect(array).to eq(%i[a x y c])
    end

    it "replaces with element at end of array" do
      array.replace_at(-1, :x)
      expect(array).to eq(%i[a b x])
    end

    it "replaces with element at index larger than current array" do
      array.replace_at 4, :x
      expect(array).to eq([:a, :b, :c, nil, :x])
    end

    it "answers replaced array" do
      expect(array.replace_at(1, :x)).to eq(%i[a x c])
    end

    it "mutates array" do
      original = array.dup
      array.replace_at 4, :x

      expect(array).not_to eq(original)
    end
  end

  describe "#ring" do
    it "answers slices without block" do
      expect([1, 2, 3].ring).to contain_exactly([1, 2, 3], [2, 3, 1], [3, 1, 2])
    end

    it "yields slices when given block" do
      expectation = []
      [1, 2, 3].ring { |slice| expectation.append slice }

      expect(expectation).to contain_exactly([1, 2, 3], [2, 3, 1], [3, 1, 2])
    end
  end

  describe "#supplant" do
    subject(:array) { %i[a b c a] }

    it "replaces first target found with single element" do
      expect(array.supplant(:a, :z)).to eq(%i[z b c a])
    end

    it "replaces first target found with multiple elements" do
      expect(array.supplant(:a, :z, :y)).to eq(%i[z y b c a])
    end

    it "answers itself" do
      expect(array.supplant(:a, :z)).to eq(array)
    end
  end

  describe "#supplant_if" do
    subject(:array) { %i[a b c a] }

    it "replaces all matching targets with single element" do
      expect(array.supplant_if(:a, :z)).to eq(%i[z b c z])
    end

    it "replaces all matching targets with multiple elements" do
      expect(array.supplant_if(:a, :z, :y)).to eq(%i[z y b c z y])
    end

    it "answers itself" do
      expect(array.supplant_if(:a, :z)).to eq(array)
    end
  end

  describe "#to_sentence" do
    it "answers empty string when empty" do
      array = []
      expect(array.to_sentence).to eq("")
    end

    it "answers single item string with one item" do
      array = ["a"]
      expect(array.to_sentence).to eq("a")
    end

    it "answers string pair with two items" do
      array = ["a", :b]
      expect(array.to_sentence).to eq("a and b")
    end

    it "answers string with three items" do
      array = [1, "b", :c]
      expect(array.to_sentence).to eq("1, b, and c")
    end

    it "answers string with multiple items using custom delimiter" do
      array = %w[eins zwei drei]
      expect(array.to_sentence(delimiter: " ")).to eq("eins zwei and drei")
    end

    it "answers string with multiple items using custom conjunction" do
      array = [1, "a", :b, 2.0, /\A\w\z/]
      expect(array.to_sentence("or")).to eq("1, a, b, 2.0, or (?-mix:\\A\\w\\z)")
    end

    it "answers string with multiple items using custom delimiter and conjunction" do
      array = %w[eins zwei drei]
      expect(array.to_sentence("und", delimiter: " ")).to eq("eins zwei und drei")
    end
  end

  describe "#to_usage" do
    it "answers empty string when empty" do
      array = []
      expect(array.to_usage).to eq("")
    end

    it "answers single item string with one item" do
      array = [:a]
      expect(array.to_usage).to eq(":a")
    end

    it "answers string with multiple items" do
      array = [1, "b", :c, 2.0, /\w+/]
      expect(array.to_usage).to eq(%(1, "b", :c, 2.0, and /\\w+/))
    end

    it "answers string with multiple items using custom delimiter and conjunction" do
      array = [1, "a", :b]
      expect(array.to_usage("or", delimiter: " ")).to eq(%(1 "a" or :b))
    end
  end
end
