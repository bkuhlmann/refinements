# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::LogDevice do
  using described_class

  subject(:device) { Logger::LogDevice.new io }

  include_context "with temporary directory"

  describe "#reread" do
    context "with file" do
      let(:io) { temp_dir.join "test.log" }

      it "answers written content" do
        device.write "This is a test."
        expect(device.reread).to include("This is a test.")
      end
    end

    context "with string" do
      let(:io) { StringIO.new }

      it "answers written content" do
        device.write "test"
        expect(device.reread).to eq("test")
      end
    end

    context "with standard output" do
      let(:io) { $stdout }

      it "answers empty string" do
        device.write "test"
        expect(device.reread).to eq("")
      end
    end
  end
end
