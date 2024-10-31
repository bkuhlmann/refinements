# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Struct do
  using described_class

  shared_examples "a merge" do |method|
    subject(:struct) { Struct.new(:a, :b, :c).new a: 1, b: 2, c: 3 }

    it "answers struct with attributes rebuilt" do
      expect(struct.public_send(method, a: 7, b: 8, c: 9)).to eq(struct.class[7, 8, 9])
    end

    it "answers struct with some attributes rebuilt" do
      expect(struct.public_send(method, a: 7, c: 9)).to eq(struct.class[7, 2, 9])
    end

    it "answers identical struct with no arguments" do
      expect(struct.public_send(method)).to eq(struct.class[1, 2, 3])
    end

    it "answers struct when given a partial hash" do
      expect(struct.public_send(method, {a: 8, c: 9})).to eq(struct.class[8, 2, 9])
    end

    it "answers struct with some attributes rebuilt and others nil'ed out" do
      partial = Struct.new(:a, :b, :c).new a: 8, c: 9
      expect(struct.public_send(method, partial)).to eq(struct.class[8, nil, 9])
    end

    it "answers struct when given a hash-like object" do
      object = Object.new.tap { |instance| def instance.to_h = {c: 9} }
      expect(struct.public_send(method, object)).to eq(struct.class[1, 2, 9])
    end
  end

  describe "#diff" do
    subject(:struct) { Struct.new :a, :b, :c }

    it "answers differences when same types are not equal" do
      one = struct.new 1, 2, 3
      two = struct.new 3, 2, 1

      expect(one.diff(two)).to eq(a: [1, 3], c: [3, 1])
    end

    it "answers differences when types are different" do
      one = struct.new 1, 2, 3
      two = Data.define

      expect(one.diff(two)).to eq(a: [1, nil], b: [2, nil], c: [3, nil])
    end

    it "answers empty hash with no differences" do
      one = struct.new 1, 2, 3
      two = struct.new 1, 2, 3

      expect(one.diff(two)).to eq({})
    end
  end

  describe "#merge" do
    it_behaves_like "a merge", :merge

    it "doesn't mutate itself" do
      struct = Struct.new(:a, :b, :c).new a: 1, b: 2, c: 3
      struct.merge a: 7, b: 8, c: 9

      expect(struct).to eq(struct.class[a: 1, b: 2, c: 3])
    end
  end

  describe "#merge!" do
    it_behaves_like "a merge", :merge!

    it "mutates itself with keywords" do
      struct = Struct.new(:a, :b, :c).new a: 1, b: 2, c: 3
      struct.merge! a: 7, b: 8, c: 9

      expect(struct).to eq(struct.class[a: 7, b: 8, c: 9])
    end
  end

  shared_examples "a transmute" do |method|
    let(:a_hash) { {r: 10, s: 20, t: 30} }

    it "transforms and merges entire struct" do
      result = struct.public_send method, other, a: :x, b: :y, c: :z
      expect(result).to eq(struct.class.new.merge!(a: 7, b: 8, c: 9))
    end

    it "transforms and merges partial struct" do
      result = struct.public_send method, other, a: :x, c: :z
      expect(result).to eq(struct.class.new.merge!(a: 7, b: 2, c: 9))
    end

    it "transforms and merges entire hash" do
      result = struct.public_send method, a_hash, a: :r, b: :s, c: :t
      expect(result).to eq(struct.class.new.merge!(a: 10, b: 20, c: 30))
    end

    it "transforms and merges partial hash" do
      result = struct.public_send method, a_hash, b: :s
      expect(result).to eq(struct.class.new.merge!(a: 1, b: 20, c: 3))
    end

    it "transforms and merges partial struct" do
      result = struct.public_send method, other, a: :x, c: :z
      expect(result).to eq(struct.class.new.merge!(a: 7, b: 2, c: 9))
    end

    it "answers original struct when no attributes are given" do
      expect(struct.public_send(method, other)).to eq(struct.class.new.merge!(a: 1, b: 2, c: 3))
    end
  end

  describe "#transmute" do
    subject(:struct) { Struct.new(:a, :b, :c).new a: 1, b: 2, c: 3 }

    let(:other) { Struct.new(:x, :y, :z).new x: 7, y: 8, z: 9 }

    it_behaves_like "a transmute", :transmute

    it "doesn't mutate itself" do
      struct.transmute other, a: :x
      expect(struct).to eq(struct.class[a: 1, b: 2, c: 3])
    end
  end

  describe "#transmute!" do
    subject(:struct) { Struct.new(:a, :b, :c).new a: 1, b: 2, c: 3 }

    let(:other) { Struct.new(:x, :y, :z).new x: 7, y: 8, z: 9 }

    it_behaves_like "a transmute", :transmute!

    it "mutates itself" do
      struct.transmute! other, a: :x
      expect(struct).to eq(struct.class[a: 7, b: 2, c: 3])
    end
  end

  describe "#with" do
    it_behaves_like "a merge", :with

    it "doesn't mutate itself" do
      struct = Struct.new(:a, :b, :c).new a: 1, b: 2, c: 3
      struct.with a: 7, b: 8, c: 9

      expect(struct).to eq(struct.class[a: 1, b: 2, c: 3])
    end
  end
end
