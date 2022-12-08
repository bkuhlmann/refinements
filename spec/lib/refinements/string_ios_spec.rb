# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::StringIOs do
  using described_class

  subject(:io) { StringIO.new }

  describe "#rewind" do
    before { io.write "This is a test." }

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
end
