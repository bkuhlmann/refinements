# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Hashes do
  using described_class

  describe ".infinite" do
    subject(:a_hash) { Hash.infinite }

    it "answers empty hash for missing top-level key" do
      expect(a_hash[:a]).to eq({})
    end

    it "answers empty hash for missing nested key" do
      expect(a_hash[:a][:b][:c]).to eq({})
    end
  end

  describe ".with_default" do
    it "answers default value for missing key" do
      default = Hash.with_default []
      expect(default[:a]).to eq([])
    end
  end

  describe "#compress" do
    subject(:a_hash) { {a: 1, b: "blueberry", c: nil, d: "", e: [], f: {}, g: object} }

    let(:object) { Object.new }

    it "answers hash without nils and empty objects" do
      expect(a_hash.compress).to eq(a: 1, b: "blueberry", g: object)
    end

    it "answers itself with nothing to remove" do
      slice = a_hash.slice(:a).compress
      expect(slice).to eq(a: 1)
    end

    it "answers itself when empty" do
      expect({}.compress).to eq({})
    end

    it "doesn't mutate itself" do
      a_hash.compress
      expect(a_hash).to eq(a: 1, b: "blueberry", c: nil, d: "", e: [], f: {}, g: object)
    end
  end

  describe "#compress!" do
    subject(:a_hash) { {a: 1, b: "blueberry", c: nil, d: "", e: [], f: {}, g: object} }

    let(:object) { Object.new }

    it "answers hash without nils and empty objects" do
      expect(a_hash.compress!).to eq(a: 1, b: "blueberry", g: object)
    end

    it "answers nil with nothing to remove" do
      slice = a_hash.slice(:a).compress!
      expect(slice).to be(nil)
    end

    it "answers nil when empty" do
      expect({}.compress!).to be(nil)
    end

    it "mutates itself" do
      a_hash.compress!
      expect(a_hash).to eq(a: 1, b: "blueberry", g: object)
    end
  end

  shared_examples "a deep merge" do |method|
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
        result = a_hash.public_send method, proof
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
        result = a_hash.public_send method, basic: {a: 1, b: [1, 2, 3]}
        expect(result).to eq(proof)
      end
    end
  end

  describe "#deep_merge" do
    it_behaves_like "a deep merge", :deep_merge

    it "doesn't mutate itself" do
      a_hash = {a: {b: 1}}
      a_hash.deep_merge a: {b: 2}

      expect(a_hash).to eq({a: {b: 1}})
    end
  end

  describe "#deep_merge!" do
    it_behaves_like "a deep merge", :deep_merge!

    it "mutates itself" do
      a_hash = {a: {b: 1}}
      a_hash.deep_merge! a: {b: 2}

      expect(a_hash).to eq(a: {b: 2})
    end
  end

  shared_examples "deep stringified keys" do |method|
    subject :a_hash do
      {
        a: [
          {b: 1}
        ],
        c: {
          d: 2
        }
      }
    end

    it "answers stringified keys" do
      expect(a_hash.public_send(method)).to eq("a" => [{b: 1}], "c" => {"d" => 2})
    end
  end

  describe "#deep_stringify_keys" do
    it_behaves_like "deep stringified keys", :deep_stringify_keys

    it "doesn't mutate hash" do
      a_hash = {a: 1}
      a_hash.deep_stringify_keys

      expect(a_hash).to eq(a: 1)
    end
  end

  describe "#deep_stringify_keys!" do
    it_behaves_like "deep stringified keys", :deep_stringify_keys!

    it "mutates itself" do
      a_hash = {a: 1}
      a_hash.deep_stringify_keys!

      expect(a_hash).to eq("a" => 1)
    end
  end

  shared_examples "deep symbolized keys" do |method|
    subject :a_hash do
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
      expect(a_hash.public_send(method)).to eq(a: [{"b" => 1}], c: {d: 2})
    end
  end

  describe "#deep_symbolize_keys" do
    it_behaves_like "deep symbolized keys", :deep_symbolize_keys

    it "doesn't mutate hash" do
      a_hash = {"a" => 1}
      a_hash.deep_symbolize_keys

      expect(a_hash).to eq("a" => 1)
    end
  end

  describe "#deep_symbolize_keys!" do
    it_behaves_like "deep symbolized keys", :deep_symbolize_keys!

    it "mutates itself" do
      a_hash = {"a" => 1}
      a_hash.deep_symbolize_keys!

      expect(a_hash).to eq(a: 1)
    end
  end

  describe "#fetch_value" do
    it "answers original value when present" do
      value = {a: "test"}.fetch_value :a, "default"
      expect(value).to eq("test")
    end

    it "answers original value when default isn't provided" do
      value = {a: "test"}.fetch_value :a
      expect(value).to eq("test")
    end

    it "answers argument default when value is missing" do
      value = {a: nil}.fetch_value :a, "default"
      expect(value).to eq("default")
    end

    it "answers block default when key is missing" do
      value = {}.fetch_value(:a) { "default" }
      expect(value).to eq("default")
    end

    it "fails when key is missing" do
      expectation = proc { {}.fetch_value :a }
      expect(&expectation).to raise_error(KeyError, /:a/)
    end

    it "fails with missing arguments" do
      expectation = proc { {}.fetch_value }
      expect(&expectation).to raise_error(ArgumentError, /wrong number of arguments/)
    end
  end

  shared_examples "flattened keys" do |method|
    it "answers same structure when keys are not nested" do
      expect({a: 1, b: 2}.public_send(method)).to eq(a: 1, b: 2)
    end

    it "answers flattened keys when keys are nested" do
      expect({a: 1, b: {c: 2}, d: 3}.public_send(method)).to eq(a: 1, b_c: 2, d: 3)
    end

    it "answers flattened keys when keys are deeply nested" do
      expect({a: 1, b: {c: 2}, d: {e: {f: 3}}}.public_send(method)).to eq(a: 1, b_c: 2, d_e_f: 3)
    end

    it "answers prefixed keys when prefix is given" do
      expect({a: 1, b: {c: 2}}.public_send(method, prefix: :test)).to eq(test_a: 1, test_b_c: 2)
    end

    it "answers flattened keys with custom delimiter" do
      expect({a: {b: 1}}.public_send(method, delimiter: :I)).to eq(aIb: 1)
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

  describe "#many?" do
    it "answers true with more than one element without block" do
      expect({a: 1, b: 2}.many?).to be(true)
    end

    it "answers true with more than one element with block" do
      result = {a: 1, b: 2, c: 2}.many? { |_key, value| value == 2 }
      expect(result).to be(true)
    end

    it "answers false with one element only" do
      expect({a: 1}.many?).to be(false)
    end

    it "answers false when empty" do
      expect({}.many?).to be(false)
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
      expect(sample.recurse(&:symbolize_keys)).to eq(a: [{"b" => 1}], c: 1)
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

  shared_examples "stringified keys" do |method|
    subject(:a_hash) { {a: 1, b: 2, "c" => 3} }

    it "answers keys as strings" do
      expect(a_hash.public_send(method).keys).to contain_exactly("a", "b", "c")
    end
  end

  describe "#stringify_keys" do
    it_behaves_like "stringified keys", :stringify_keys

    it "doesn't mutate itself" do
      a_hash = {a: 1}
      a_hash.stringify_keys

      expect(a_hash).to eq(a: 1)
    end
  end

  describe "#stringify_keys!" do
    it_behaves_like "stringified keys", :stringify_keys!

    it "mutates itself" do
      a_hash = {a: 1}
      a_hash.stringify_keys!

      expect(a_hash).to eq("a" => 1)
    end
  end

  shared_examples "symbolized keys" do |method|
    subject(:a_hash) { {"a" => 1, "b" => 2, c: 3} }

    it "answers keys as symbols" do
      expect(a_hash.public_send(method).keys).to contain_exactly(:a, :b, :c)
    end
  end

  describe "#symbolize_keys" do
    it_behaves_like "symbolized keys", :symbolize_keys

    it "doesn't mutate itself" do
      a_hash = {"a" => 1}
      a_hash.symbolize_keys

      expect(a_hash).to eq("a" => 1)
    end
  end

  describe "#symbolize_keys!" do
    it_behaves_like "symbolized keys", :symbolize_keys!

    it "mutates itself" do
      a_hash = {"a" => 1}
      a_hash.symbolize_keys!

      expect(a_hash).to eq(a: 1)
    end
  end

  shared_examples "a transform" do |method|
    subject(:a_hash) { {name: "Jayne Doe", email: "<jd@example.com>"} }

    it "answers transformed values" do
      result = a_hash.public_send method,
                                  name: -> value { value.delete_suffix " Doe" },
                                  email: -> value { value.tr "<>", "" }

      expect(result).to eq(name: "Jayne", email: "jd@example.com")
    end

    it "ignores invalid keys" do
      result = a_hash.public_send method, bogus: -> value { value.tr "<>", "" }
      expect(result).to eq(a_hash)
    end
  end

  describe "#transform_with" do
    it_behaves_like "a transform", :transform_with

    it "doesn't mutate itself" do
      a_hash = {email: "<test@example.com>"}
      a_hash.transform_with email: -> value { value.tr "<>", "" }

      expect(a_hash).to eq(email: "<test@example.com>")
    end
  end

  describe "#transform_with!" do
    it_behaves_like "a transform", :transform_with!

    it "mutates itself" do
      a_hash = {email: "<test@example.com>"}
      a_hash.transform_with! email: -> value { value.tr "<>", "" }

      expect(a_hash).to eq(email: "test@example.com")
    end
  end

  describe "#use" do
    subject(:a_hash) { {width: 10, height: 5, depth: 22} }

    it "answers result of selected values where keys are symbols" do
      area = a_hash.use { |width, height| width * height }
      expect(area).to eq(50)
    end

    it "answers result of selected values where keys are strings" do
      a_hash = {"width" => 10, "height" => 5, "depth" => 22}
      area = a_hash.use { |width, height| width * height }

      expect(area).to eq(50)
    end

    it "answers empty array when no block is given" do
      expect(a_hash.use).to eq([])
    end
  end
end
