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

  describe "#deep_merge" do
    subject :hashes do
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

    context "with identical keys" do
      let :proof do
        {
          label: "Test",
          nested: {
            level_1: {
              value: "test"
            },
            level_2: %w[x y z]
          }
        }
      end

      it "replaces all values" do
        result = hashes.deep_merge proof
        expect(result).to eq(proof)
      end
    end

    context "with new keys" do
      let :proof do
        {
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
      end

      it "merges structure with existing structure" do
        result = hashes.deep_merge basic: {a: 1, b: [1, 2, 3]}
        expect(result).to eq(proof)
      end
    end

    it "does not modify itself" do
      proof = hashes.dup
      hashes.deep_merge label: "Test"

      expect(hashes).to eq(proof)
    end
  end

  describe "#deep_merge!" do
    subject :hashes do
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

    context "with identical keys" do
      let :proof do
        {
          label: "Test",
          nested: {
            level_1: {
              value: "test"
            },
            level_2: %w[x y z]
          }
        }
      end

      it "replaces all values" do
        result = hashes.deep_merge! proof
        expect(result).to eq(proof)
      end
    end

    context "with new keys" do
      let :proof do
        {
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
      end

      it "merges structure with existing structure" do
        result = hashes.deep_merge! basic: {a: 1, b: [1, 2, 3]}
        expect(result).to eq(proof)
      end
    end

    it "modifies itself" do
      proof = hashes.dup.merge label: "Test"
      hashes.deep_merge! label: "Test"

      expect(hashes).to eq(proof)
    end
  end

  describe "#recurse" do
    let :sample do
      {
        "a" => [
          {"b" => 1}
        ],
        "c" => 1
      }
    end

    it "recursively processes nested hash" do
      expect(sample.recurse(&:symbolize_keys)).to eq(
        a: [
          {"b" => 1}
        ],
        c: 1
      )
    end

    it "does not mutate itself" do
      example = {"a" => 1}
      example.recurse(&:symbolize_keys)

      expect(example).to eq("a" => 1)
    end

    it "answers self when not given a block" do
      example = {a: 1}
      expect(example.recurse).to equal(example)
    end
  end

  describe "#rekey" do
    let(:mapping) { {a: :apples, b: :blueberries} }

    it "answers rekeyed hash of smaller size" do
      expect({a: 1}.rekey(mapping)).to eq(apples: 1)
    end

    it "answers rekeyed hash of equal size" do
      expect({a: 1, b: 2}.rekey(mapping)).to eq(apples: 1, blueberries: 2)
    end

    it "answers rekeyed hash of larger size" do
      expect({a: 1, b: 2, c: 3}.rekey(mapping)).to eq(apples: 1, blueberries: 2, c: 3)
    end

    it "answers original hash with no mapping" do
      expect({a: 1, b: 2}.rekey).to eq(a: 1, b: 2)
    end

    it "answers empty hash for empty hash and mapping" do
      expect({}.rekey(mapping)).to eq({})
    end

    it "does not mutate hash" do
      sample = {a: 1, b: 2}
      sample.rekey mapping

      expect(sample).to eq(a: 1, b: 2)
    end
  end

  describe "#rekey!" do
    let(:mapping) { {a: :apples, b: :blueberries} }

    it "answers rekeyed hash" do
      expect({a: 1, b: 2}.rekey!(mapping)).to eq(apples: 1, blueberries: 2)
    end

    it "answers original hash with no mapping" do
      expect({a: 1, b: 2}.rekey!).to eq(a: 1, b: 2)
    end

    it "answers empty hash for empty hash and mapping" do
      expect({}.rekey!(mapping)).to eq({})
    end

    it "mutates hash" do
      sample = {a: 1, b: 2}
      sample.rekey! mapping

      expect(sample).to eq(apples: 1, blueberries: 2)
    end
  end

  describe "#reverse_merge" do
    subject :hashes do
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

    it "outputs deprecation warning" do
      result = proc { hashes.reverse_merge label: "test" }
      expect(&result).to output(/DEPRECATION/).to_stderr
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

    it "outputs deprecation warning" do
      result = proc { hashes.reverse_merge! c: 3 }
      expect(&result).to output(/DEPRECATION/).to_stderr
    end

    it "modifies itself" do
      proof = {a: 1, b: 2, c: 3}
      hashes.reverse_merge! c: 3

      expect(hashes).to eq(proof)
    end
  end

  describe "#deep_symbolize_keys" do
    let :sample do
      {
        "a" => [
          {"b" => 1}
        ],
        "c" => {
          "d" => 2
        }
      }
    end

    it "answers symbolized keys" do
      expect(sample.deep_symbolize_keys).to eq(
        a: [
          {"b" => 1}
        ],
        c: {
          d: 2
        }
      )
    end

    it "does not mutate hash" do
      example = {"a" => 1}
      example.deep_symbolize_keys

      expect(example).to eq("a" => 1)
    end
  end

  describe "#deep_symbolize_keys!" do
    let :sample do
      {
        "a" => [
          {"b" => 1}
        ],
        "c" => {
          "d" => 2
        }
      }
    end

    it "answers symbolized keys" do
      expect(sample.deep_symbolize_keys!).to eq(
        a: [
          {"b" => 1}
        ],
        c: {
          d: 2
        }
      )
    end

    it "mutates hash" do
      example = {"a" => 1}
      example.deep_symbolize_keys!

      expect(example).to eq(a: 1)
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
