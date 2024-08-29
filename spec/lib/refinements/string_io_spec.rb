# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::StringIO do
  using described_class

  subject(:io) { StringIO.new }

  before { io.write "This is a test." }

  describe "#rewind" do
    it "answers full string" do
      expect(io.reread).to eq("This is a test.")
    end

    it "answers partial string" do
      expect(io.reread(4)).to eq("This")
    end

    it "writes to buffer" do
      buffer = +""
      io.reread(buffer:)

      expect(buffer).to eq("This is a test.")
    end
  end

  describe "#to_s" do
    it "answers string" do
      expect(io.to_s).to eq("This is a test.")
    end
  end

  describe "#to_str" do
    it "answers string" do
      expect(io.to_str).to eq("This is a test.")
    end
  end
end
