# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Hashes do
  using Refinements::Hashes

  describe "#except" do
    subject { {a: 1, b: 2, c: 3} }

    it "answers subset of original hash" do
      expect(subject.except(:a, :b)).to eq(c: 3)
    end

    it "does not modify original hash" do
      subject.except :a, :b
      expect(subject).to eq(a: 1, b: 2, c: 3)
    end
  end

  describe "#except!" do
    subject { {a: 1, b: 2, c: 3} }

    it "answers subset of original hash" do
      expect(subject.except!(:a, :b)).to eq(c: 3)
    end

    it "does not modify original hash" do
      subject.except! :a, :b
      expect(subject).to eq(c: 3)
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

  describe "#deep_merge" do
    subject do
      {
        label: "Example",
        nested: {
          level_1: {
            value: "example"
          },
          level_2: %w[a b c]
        }
      }
    end

    it "merges existing values" do
      proof = {
        label: "Test",
        nested: {
          level_1: {
            value: "test"
          },
          level_2: %w[x y z]
        }
      }

      result = subject.deep_merge label: "Test",
                                  nested: {
                                    level_1: {
                                      value: "test"
                                    },
                                    level_2: %w[x y z]
                                  }

      expect(result).to eq(proof)
    end

    it "merges new values" do
      proof = {
        label: "Example",
        basic: {
          a: 1,
          b: [1, 2, 3]
        },
        nested: {
          level_1: {
            value: "example"
          },
          level_2: %w[a b c]
        }
      }

      result = subject.deep_merge basic: {a: 1, b: [1, 2, 3]}

      expect(result).to eq(proof)
    end

    it "does not modify itself" do
      proof = {
        label: "Example",
        nested: {
          level_1: {
            value: "example"
          },
          level_2: %w[a b c]
        }
      }

      subject.deep_merge label: "Test"

      expect(subject).to eq(proof)
    end
  end

  describe "#deep_merge!" do
    subject do
      {
        label: "Example",
        nested: {
          level_1: {
            value: "example"
          },
          level_2: %w[a b c]
        }
      }
    end

    it "merges existing values" do
      proof = {
        label: "Test",
        nested: {
          level_1: {
            value: "test"
          },
          level_2: %w[x y z]
        }
      }

      result = subject.deep_merge! label: "Test",
                                   nested: {
                                     level_1: {
                                       value: "test"
                                     },
                                     level_2: %w[x y z]
                                   }

      expect(result).to eq(proof)
    end

    it "merges new values" do
      proof = {
        label: "Example",
        basic: {
          a: 1,
          b: [1, 2, 3]
        },
        nested: {
          level_1: {
            value: "example"
          },
          level_2: %w[a b c]
        }
      }

      result = subject.deep_merge! basic: {a: 1, b: [1, 2, 3]}

      expect(result).to eq(proof)
    end

    it "modifies itself" do
      proof = {
        label: "Test",
        nested: {
          level_1: {
            value: "example"
          },
          level_2: %w[a b c]
        }
      }

      subject.deep_merge! label: "Test"

      expect(subject).to eq(proof)
    end
  end

  describe "#reverse_merge" do
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
    subject { {a: 1, b: 2} }

    it "modifies itself" do
      proof = {a: 1, b: 2, c: 3}
      subject.reverse_merge! c: 3

      expect(subject).to eq(proof)
    end
  end

  describe "#use" do
    subject { {width: 10, height: 5, depth: 22} }

    it "answers result of selected values" do
      area = subject.use { |width, height| width * height }
      expect(area).to eq(50)
    end

    it "answers empty array when no block is given" do
      expect(subject.use).to eq([])
    end
  end
end
