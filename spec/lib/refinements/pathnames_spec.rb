# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Pathnames do
  using described_class

  describe ".rewrite", :temp_dir do
    let(:test_path) { temp_dir.join "test.txt" }

    before { test_path.write "This is a [text]." }

    it "reads and writes file" do
      test_path.rewrite { |content| content.sub "[text]", "test" }
      expect(test_path.read).to eq("This is a test.")
    end
  end
end
