# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Hashes do
  using described_class

  describe "#except" do
    subject(:hashes) { {a: 1, b: 2, c: 3} }

    it "answers subset of original hash" do
      expect(hashes.except(:a, :b)).to eq(c: 3)
    end

    it "does not modify original hash" do
      hashes.except :a, :b
      expect(hashes).to eq(a: 1, b: 2, c: 3)
    end
  end

  describe "#except!" do
    subject(:hashes) { {a: 1, b: 2, c: 3} }

    it "answers subset of original hash" do
      expect(hashes.except!(:a, :b)).to eq(c: 3)
    end

    it "does not modify original hash" do
      hashes.except! :a, :b
      expect(hashes).to eq(c: 3)
    end
  end

  describe "#symbolize_keys" do
    subject(:hashes) { {"a" => 1, "b" => 2, c: 3} }

    it "answers keys as symbols" do
      expect(hashes.symbolize_keys.keys).to contain_exactly(:a, :b, :c)
    end

    it "does not modify original hash" do
      hashes.symbolize_keys
      expect(hashes).to eq("a" => 1, "b" => 2, c: 3)
    end
  end

  describe "#symbolize_keys!" do
    subject(:hashes) { {"a" => 1, "b" => 2, c: 3} }

    it "answers keys as symbols" do
      expect(hashes.symbolize_keys!.keys).to contain_exactly(:a, :b, :c)
    end

    it "modifies original hash" do
      hashes.symbolize_keys!
      expect(hashes).to eq(a: 1, b: 2, c: 3)
    end
  end

  # rubocop:disable RSpec/ExampleLength
  describe "#deep_merge" do
    subject(:hashes) do
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

      result = hashes.deep_merge label: "Test",
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

      result = hashes.deep_merge basic: {a: 1, b: [1, 2, 3]}

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

      hashes.deep_merge label: "Test"

      expect(hashes).to eq(proof)
    end
  end
  # rubocop:enable RSpec/ExampleLength

  # rubocop:disable RSpec/ExampleLength
  describe "#deep_merge!" do
    subject(:hashes) do
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

      result = hashes.deep_merge! label: "Test",
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

      result = hashes.deep_merge! basic: {a: 1, b: [1, 2, 3]}

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

      hashes.deep_merge! label: "Test"

      expect(hashes).to eq(proof)
    end
  end
  # rubocop:enable RSpec/ExampleLength

  describe "#reverse_merge" do
    subject(:hashes) do
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
      result = hashes.reverse_merge label: "empty", categories: "empty", tags: "empty"
      expect(result).to eq(hashes)
    end

    it "answers merged keys not part of self" do
      proof = hashes.dup.merge test: "example"
      result = hashes.reverse_merge test: "example"

      expect(result).to eq(proof)
    end

    it "does not modify itself" do
      proof = hashes.dup
      hashes.reverse_merge test: "Example"

      expect(hashes).to eq(proof)
    end
  end

  describe "#reverse_merge!" do
    subject(:hashes) { {a: 1, b: 2} }

    it "modifies itself" do
      proof = {a: 1, b: 2, c: 3}
      hashes.reverse_merge! c: 3

      expect(hashes).to eq(proof)
    end
  end

  describe "#use" do
    subject(:hashes) { {width: 10, height: 5, depth: 22} }

    it "answers result of selected values" do
      area = hashes.use { |width, height| width * height }
      expect(area).to eq(50)
    end

    it "answers empty array when no block is given" do
      expect(hashes.use).to eq([])
    end
  end
end
