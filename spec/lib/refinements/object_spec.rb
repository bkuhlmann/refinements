# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Object do
  using described_class

  describe "#in?" do
    shared_examples "an includeable" do
      it "answers true when included" do
        expect("a".in?(collection)).to be(true)
      end

      it "answers false when not included" do
        expect("z".in?(collection)).to be(false)
      end

      it "fails when unable to support inclusion" do
        expectation = proc { "a".in? Object.new }
        expect(&expectation).to raise_error(NoMethodError, "`String#include?` must be implemented.")
      end
    end

    context "with array" do
      let(:collection) { %w[a b c] }

      it_behaves_like "an includeable"
    end

    context "with enumerable" do
      let(:collection) { %w[a b c].to_enum }

      it_behaves_like "an includeable"
    end

    context "with hash" do
      let(:collection) { {"a" => 1, "b" => 2, "c" => 3} }

      it_behaves_like "an includeable"
    end

    context "with range" do
      let(:collection) { "a".."f" }

      it_behaves_like "an includeable"
    end

    context "with set" do
      let(:collection) { Set["a", "b", "c"] }

      it_behaves_like "an includeable"
    end

    context "with string" do
      let(:collection) { "abcdef" }

      it_behaves_like "an includeable"
    end
  end

  describe "#to_proc" do
    subject(:implementation) { Class.new { def call = :test } }

    it "casts when implemented" do
      expect(implementation.new.to_proc).to be_a(Proc)
    end

    it "fails when not implemented" do
      expectation = proc { Object.new.to_proc }
      expect(&expectation).to raise_error(NoMethodError, "`Object#call` must be implemented.")
    end
  end
end
