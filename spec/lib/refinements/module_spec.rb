# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Module do
  using described_class

  describe "#pseudonym" do
    it "answers temporary name with object ID for module" do
      expect(Module.new.pseudonym("test").name).to match(/test-\d+/)
    end

    it "answers temporary name with object ID for class" do
      expect(Class.new.pseudonym("test").name).to match(/test-\d+/)
    end

    it "answers temporary name with custom delimiter" do
      expect(Module.new.pseudonym("test", delimiter: "_").name).to match(/test_\d+/)
    end

    it "answers temporary name with no suffix" do
      expect(Module.new.pseudonym("test", nil).name).to eq("test-")
    end

    it "answers temporary name with no delimiter or suffix" do
      expect(Module.new.pseudonym("test", nil, delimiter: nil).name).to eq("test")
    end
  end
end
