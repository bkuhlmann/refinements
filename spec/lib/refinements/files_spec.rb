# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Files do
  using described_class

  describe ".rewrite", :temp_dir do
    let(:test_path) { temp_dir.join "test.txt" }

    before { File.write test_path, "One" }

    it "reads and writes file" do
      File.rewrite(test_path) { |content| "#{content} Two" }
      expect(File.read(test_path)).to eq("One Two")
    end

    it "outputs deprecation warning" do
      result = proc { File.rewrite(test_path) { |content| "#{content} Two" } }
      expect(&result).to output(/DEPRECATION/).to_stderr
    end
  end
end
