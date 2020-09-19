# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Hashes do
  using described_class

  describe ".infinite" do
    subject(:infinite) { Hash.infinite }

    it "answers empty hash for missing top-level key" do
      expect(infinite[:a]).to eq({})
    end

    it "answers empty hash for missing nested key" do
      expect(infinite[:a][:b][:c]).to eq({})
    end
  end

  describe ".with_default" do
    it "answers default value for missing key" do
      default = Hash.with_default []
      expect(default[:a]).to eq([])
    end
  end

  describe "#except" do
    subject(:a_hash) { {a: 1, b: 2, c: 3} }

    it "answers subset of itself" do
      expect(a_hash.except(:a, :b)).to eq(c: 3)
    end

    it "doesn't mutate itself" do
      a_hash.except :a, :b
      expect(a_hash).to eq(a: 1, b: 2, c: 3)
    end
  end

  describe "#except!" do
    subject(:a_hash) { {a: 1, b: 2, c: 3} }

    it "answers subset of itself" do
      expect(a_hash.except!(:a, :b)).to eq(c: 3)
    end

    it "mutates itself" do
      a_hash.except! :a, :b
      expect(a_hash).to eq(c: 3)
    end
  end

  shared_examples_for "flattened keys" do |method|
    it "fails with unknown cast" do
      expectation = proc { Hash.new.flatten_keys cast: :invalid }
      expect(&expectation).to raise_error(StandardError, "Unknown cast: invalid.")
    end

    it "answers same structure when keys are not nested" do
      expect({a: 1, b: 2}.public_send(method)).to eq(a: 1, b: 2)
    end

    it "answers flattened keys when keys are nested" do
      expect({a: 1, b: {c: 2}, d: 3}.public_send(method)).to eq(a: 1, b_c: 2, d: 3)
    end

    it "answers flattened keys when keys are deeply nested" do
      expect({a: 1, b: {c: 2}, d: {e: {f: 3}}}.public_send(method)).to eq(
        a: 1,
        b_c: 2,
        d_e_f: 3
      )
    end

    it "answers prefixed keys when prefix is given" do
      expect({a: 1, b: {c: 2}}.public_send(method, prefix: :test)).to eq(test_a: 1, test_b_c: 2)
    end

    it "answers flattened keys with custom delimiter" do
      expect({a: {b: 1}}.public_send(method, delimiter: :I)).to eq(aIb: 1)
    end

    it "answers flattened, string keys when cast is a string" do
      expect({a: {b: 1}}.public_send(method, cast: :to_s)).to eq("a_b" => 1)
    end

    it "answers flattened, symbol keys when cast is a symbol" do
      expect({"a" => {"b" => 1}}.public_send(method, cast: :to_sym)).to eq(a_b: 1)
    end

    it "answers empty hash when hash is empty" do
      expect({}.public_send(method)).to eq({})
    end
  end

  describe "#flatten_keys" do
    it_behaves_like "flattened keys", :flatten_keys

    it "doesn't mutate itself" do
      a_hash = {a: {b: 1}}
      a_hash.flatten_keys

      expect(a_hash).to eql(a: {b: 1})
    end
  end

  describe "#flatten_keys!" do
    it_behaves_like "flattened keys", :flatten_keys!

    it "mutates itself" do
      a_hash = {a: {b: 1}}
      a_hash.flatten_keys!

      expect(a_hash).to eql(a_b: 1)
    end
  end

  describe "#symbolize_keys" do
    subject(:a_hash) { {"a" => 1, "b" => 2, c: 3} }

    it "answers keys as symbols" do
      expect(a_hash.symbolize_keys.keys).to contain_exactly(:a, :b, :c)
    end

    it "doesn't mutate itself" do
      a_hash.symbolize_keys
      expect(a_hash).to eq("a" => 1, "b" => 2, c: 3)
    end
  end

  describe "#symbolize_keys!" do
    subject(:a_hash) { {"a" => 1, "b" => 2, c: 3} }

    it "answers keys as symbols" do
      expect(a_hash.symbolize_keys!.keys).to contain_exactly(:a, :b, :c)
    end

    it "mutates itself" do
      a_hash.symbolize_keys!
      expect(a_hash).to eq(a: 1, b: 2, c: 3)
    end
  end

  describe "#deep_merge" do
    subject :a_hash do
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
        result = a_hash.deep_merge proof
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
        result = a_hash.deep_merge basic: {a: 1, b: [1, 2, 3]}
        expect(result).to eq(proof)
      end
    end

    it "doesn't mutate itself" do
      proof = a_hash.dup
      a_hash.deep_merge label: "Test"

      expect(a_hash).to eq(proof)
    end
  end

  describe "#deep_merge!" do
    subject :a_hash do
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
        result = a_hash.deep_merge! proof
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
        result = a_hash.deep_merge! basic: {a: 1, b: [1, 2, 3]}
        expect(result).to eq(proof)
      end
    end

    it "mutates itself" do
      proof = a_hash.dup.merge label: "Test"
      a_hash.deep_merge! label: "Test"

      expect(a_hash).to eq(proof)
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

    it "doesn't mutate itself" do
      example = {"a" => 1}
      example.recurse(&:symbolize_keys)

      expect(example).to eq("a" => 1)
    end

    it "answers itself when not given a block" do
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

    it "answers itself with no mapping" do
      expect({a: 1, b: 2}.rekey).to eq(a: 1, b: 2)
    end

    it "answers empty hash for empty hash and mapping" do
      expect({}.rekey(mapping)).to eq({})
    end

    it "doesn't mutate hash" do
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

    it "answers itself with no mapping" do
      expect({a: 1, b: 2}.rekey!).to eq(a: 1, b: 2)
    end

    it "answers empty hash for empty hash and mapping" do
      expect({}.rekey!(mapping)).to eq({})
    end

    it "mutates itself" do
      sample = {a: 1, b: 2}
      sample.rekey! mapping

      expect(sample).to eq(apples: 1, blueberries: 2)
    end
  end

  describe "#reverse_merge" do
    subject :a_hash do
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
      result = proc { a_hash.reverse_merge label: "test" }
      expect(&result).to output(/DEPRECATION/).to_stderr
    end

    it "answers itself when keys match" do
      result = a_hash.reverse_merge label: "empty", categories: "empty", tags: "empty"
      expect(result).to eq(a_hash)
    end

    it "answers merged keys not part of itself" do
      proof = a_hash.dup.merge test: "example"
      result = a_hash.reverse_merge test: "example"

      expect(result).to eq(proof)
    end

    it "doesn't mutate itself" do
      proof = a_hash.dup
      a_hash.reverse_merge test: "Example"

      expect(a_hash).to eq(proof)
    end
  end

  describe "#reverse_merge!" do
    subject(:a_hash) { {a: 1, b: 2} }

    it "outputs deprecation warning" do
      result = proc { a_hash.reverse_merge! c: 3 }
      expect(&result).to output(/DEPRECATION/).to_stderr
    end

    it "mutates itself" do
      proof = {a: 1, b: 2, c: 3}
      a_hash.reverse_merge! c: 3

      expect(a_hash).to eq(proof)
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

    it "doesn't mutate hash" do
      a_hash = {"a" => 1}
      a_hash.deep_symbolize_keys

      expect(a_hash).to eq("a" => 1)
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

    it "mutates itself" do
      a_hash = {"a" => 1}
      a_hash.deep_symbolize_keys!

      expect(a_hash).to eq(a: 1)
    end
  end

  describe "#use" do
    subject(:a_hash) { {width: 10, height: 5, depth: 22} }

    it "answers result of selected values" do
      area = a_hash.use { |width, height| width * height }
      expect(area).to eq(50)
    end

    it "answers empty array when no block is given" do
      expect(a_hash.use).to eq([])
    end
  end
end
