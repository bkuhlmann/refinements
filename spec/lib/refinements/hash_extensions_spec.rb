# frozen_string_literal: true

require "spec_helper"
require "refinements/hash_extensions"

RSpec.describe Refinements::HashExtensions do
  using Refinements::HashExtensions

  subject do
    {
      label: "Kaleidoscope",
      categories: {
        colors: %w(red black white cyan),
        styles: %w(solid dotted)
      },
      tags: {
        emoji: {
          faces: {
            happy: %w(happy estatic),
            confused: %w(pensive sweating),
            sad: "frown"
          }
        },
        positive: "red",
        negative: "black"
      }
    }
  end

  describe "#deep_merge" do
    it "merges nested hash" do
      proof = subject.merge tags: {emoji: {faces: "test"}, positive: "red", negative: "black", neutral: "grey"}
      result = subject.deep_merge tags: {emoji: {faces: "test"}, neutral: "grey"}

      expect(result).to eq(proof)
    end

    it "does not modify itself" do
      proof = subject.dup
      subject.deep_merge categories: {colors: %w(yellow brown)}

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
