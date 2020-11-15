# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Structs do
  using described_class

  shared_examples_for "a merge" do |method|
    context "with positional construction" do
      let(:blueprint) { Struct.new :a, :b, :c }
      let(:struct) { blueprint[1, 2, 3] }

      it "answers struct with all attributes rebuilt" do
        expect(struct.public_send(method, a: 7, b: 8, c: 9)).to eq(blueprint[7, 8, 9])
      end

      it "answers struct with some attributes rebuilt" do
        expect(struct.public_send(method, a: 7, c: 9)).to eq(blueprint[7, 2, 9])
      end

      it "answers identical struct with no arguments" do
        expect(struct.public_send(method)).to eq(blueprint[1, 2, 3])
      end
    end

    context "with keyword construction" do
      let(:blueprint) { Struct.new :a, :b, :c, keyword_init: true }
      let(:struct) { blueprint[a: 1, b: 2, c: 3] }

      it "answers struct with all attributes rebuilt" do
        expect(struct.public_send(method, a: 7, b: 8, c: 9)).to eq(blueprint[a: 7, b: 8, c: 9])
      end

      it "answers struct with some attributes rebuilt" do
        expect(struct.public_send(method, a: 7, c: 9)).to eq(blueprint[a: 7, b: 2, c: 9])
      end

      it "answers identical struct with no arguments" do
        expect(struct.public_send(method)).to eq(blueprint[a: 1, b: 2, c: 3])
      end
    end
  end

  describe "#merge" do
    it_behaves_like "a merge", :merge

    it "doesn't mutate itself with positional construction" do
      blueprint = Struct.new :a, :b, :c
      struct = blueprint[1, 2, 3]
      struct.merge a: 7, b: 8, c: 9

      expect(struct).to eq(blueprint[1, 2, 3])
    end

    it "doesn't mutate itself with keyword construction" do
      blueprint = Struct.new :a, :b, :c, keyword_init: true
      struct = blueprint[a: 1, b: 2, c: 3]
      struct.merge a: 7, b: 8, c: 9

      expect(struct).to eq(blueprint[a: 1, b: 2, c: 3])
    end
  end

  describe "#merge!" do
    it_behaves_like "a merge", :merge!

    it "mutates itself with positional construction" do
      blueprint = Struct.new :a, :b, :c
      struct = blueprint[1, 2, 3]
      struct.merge! a: 7, b: 8, c: 9

      expect(struct).to eq(blueprint[7, 8, 9])
    end

    it "mutates itself with keyword construction" do
      blueprint = Struct.new :a, :b, :c, keyword_init: true
      struct = blueprint[a: 1, b: 2, c: 3]
      struct.merge! a: 7, b: 8, c: 9

      expect(struct).to eq(blueprint[a: 7, b: 8, c: 9])
    end
  end
end
