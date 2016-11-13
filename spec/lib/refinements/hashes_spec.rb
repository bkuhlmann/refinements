# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Hashes do
  using Refinements::Hashes

  subject do
    {
      label: "Kaleidoscope",
      categories: {
        colors: %w[red black white cyan],
        styles: %w[solid dotted]
      },
      tags: {
        emoji: {
          faces: {
            happy: %w[happy estatic],
            confused: %w[pensive sweating],
            sad: "frown"
          }
        },
        positive: "red",
        negative: "black"
      }
    }
  end

  describe "#compact" do
    subject { {a: 1, b: nil} }

    it "answers hash with key/value pairs removed which had nil values" do
      expect(subject.compact).to eq(a: 1)
    end

    it "does not modify original hash" do
      subject.compact
      expect(subject).to eq(a: 1, b: nil)
    end

    it "prints deprecation warning" do
      result = -> { subject.compact }
      expect(&result).to output(/#compact is deprecated/).to_stdout
    end
  end

  describe "#compact!" do
    subject { {a: 1, b: nil} }

    it "answers hash with key/value pairs removed which had nil values" do
      expect(subject.compact!).to eq(a: 1)
    end

    it "modifies original hash" do
      subject.compact!
      expect(subject).to eq(a: 1)
    end

    it "prints deprecation warning" do
      result = -> { subject.compact! }
      expect(&result).to output(/#compact! is deprecated/).to_stdout
    end
  end

  describe "#symbolize_keys" do
    subject { {"a" => 1, "b" => 2, c: 3} }

    it "answers keys as symbols" do
      expect(subject.symbolize_keys.keys).to contain_exactly(:a, :b, :c)
    end

    it "does not modify original hash" do
      subject.symbolize_keys
      expect(subject).to eq("a" => 1, "b" => 2, c: 3)
    end
  end

  describe "#symbolize_keys!" do
    subject { {"a" => 1, "b" => 2, c: 3} }

    it "answers keys as symbols" do
      expect(subject.symbolize_keys!.keys).to contain_exactly(:a, :b, :c)
    end

    it "modifies original hash" do
      subject.symbolize_keys!
      expect(subject).to eq(a: 1, b: 2, c: 3)
    end
  end

  describe "#slice" do
    subject { {a: 1, b: 2, c: 3} }

    it "answers subset of original hash" do
      expect(subject.slice(:a, :b)).to eq(a: 1, b: 2)
    end

    it "does not modify original hash" do
      subject.slice :a, :b
      expect(subject).to eq(a: 1, b: 2, c: 3)
    end
  end

  describe "#slice!" do
    subject { {a: 1, b: 2, c: 3} }

    it "answers subset of original hash" do
      expect(subject.slice!(:a, :b)).to eq(a: 1, b: 2)
    end

    it "does not modify original hash" do
      subject.slice! :a, :b
      expect(subject).to eq(a: 1, b: 2)
    end
  end

  describe "#deep_merge" do
    it "merges nested hash" do
      proof = subject.merge tags: {emoji: {faces: "test"}, positive: "red", negative: "black", neutral: "grey"}
      result = subject.deep_merge tags: {emoji: {faces: "test"}, neutral: "grey"}

      expect(result).to eq(proof)
    end

    it "does not modify itself" do
      proof = subject.dup
      subject.deep_merge categories: {colors: %w[yellow brown]}

      expect(subject).to eq(proof)
    end
  end

  describe "#deep_merge!" do
    it "modifies itself" do
      proof = subject.merge tags: {emoji: {faces: "test"}, positive: "red", negative: "black"}
      subject.deep_merge! tags: {emoji: {faces: "test"}}

      expect(subject).to eq(proof)
    end
  end

  describe "#reverse_merge" do
    it "answers itself when keys match" do
      result = subject.reverse_merge label: "empty", categories: "empty", tags: "empty"
      expect(result).to eq(subject)
    end

    it "answers merged keys not part of self" do
      proof = subject.dup.merge test: "example"
      result = subject.reverse_merge test: "example"

      expect(result).to eq(proof)
    end

    it "does not modify itself" do
      proof = subject.dup
      subject.reverse_merge test: "Example"

      expect(subject).to eq(proof)
    end
  end

  describe "#reverse_merge!" do
    it "modifies itself" do
      proof = subject.dup.merge test: "example"
      subject.reverse_merge! test: "example"

      expect(subject).to eq(proof)
    end
  end
end
