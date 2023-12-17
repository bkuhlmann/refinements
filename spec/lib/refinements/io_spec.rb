# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::IO do
  subject(:io) { IO.new IO.sysopen(main_path.to_s, "w+") }

  include_context "with temporary directory"

  using described_class
  using Refinements::Pathname

  let(:main_path) { temp_dir.join("main.io").touch }

  describe ".void" do
    subject(:io) { IO.void }

    it "answers stream for /dev/null" do
      expect(io.inspect).to match(/IO:fd \d+/)
    end

    it "answers stream in read/write mode" do
      expect(io.stat.mode).to eq(8630)
    end

    it "doesn't auto-close when not given a block" do
      expect(io.closed?).to be(false)
    end

    it "auto-closes when given a block" do
      io = IO.void { |void| void.write "nevermore" }
      expect(io.closed?).to be(true)
    end
  end

  describe "#redirect" do
    let(:other) { IO.new IO.sysopen(other_path.to_s, "w+") }
    let(:other_path) { temp_dir.join("other.io").touch }

    it "redirects stream with block" do
      io.redirect(other) { |stream| stream.write "test" }
        .close
      other.close

      expect([main_path.read, other_path.read]).to eq(["", "test"])
    end

    it "does nothing without block" do
      io.redirect(other).close
      other.close

      expect([main_path.read, other_path.read]).to eq(["", ""])
    end
  end

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

  describe "#squelch" do
    it "answers self when not given a block" do
      expect(io.squelch).to eq(io)
    end

    it "ignores reads when given a block" do
      io.write "test"
      io.squelch { io.rewind }

      expect([io.read, io.reread]).to eq(["", "test"])
    end

    it "ignores writes when given a block" do
      io.squelch { io.write "test" }
        .close

      expect(main_path.read).to eq("")
    end
  end
end
