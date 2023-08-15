# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Data do
  using described_class

  describe "#diff" do
    subject(:data) { Data.define :a, :b, :c }

    it "answers differences when same types are not equal" do
      one = data.new 1, 2, 3
      two = data.new 3, 2, 1

      expect(one.diff(two)).to eq(a: [1, 3], c: [3, 1])
    end

    it "answers differences when types are different" do
      one = data.new 1, 2, 3
      two = Struct.new :a, :b, :c

      expect(one.diff(two)).to eq(a: [1, nil], b: [2, nil], c: [3, nil])
    end

    it "answers empty hash with no differences" do
      one = data.new 1, 2, 3
      two = data.new 1, 2, 3

      expect(one.diff(two)).to eq({})
    end
  end
end
