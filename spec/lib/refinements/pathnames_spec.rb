# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Pathnames, :temp_dir do
  using described_class

  describe "#name" do
    it "answers name of file without extension" do
      path = Pathname "example.txt"
      expect(path.name).to eq(Pathname("example"))
    end

    it "answers empty string when empty string" do
      path = Pathname ""
      expect(path.name).to eq(Pathname(""))
    end
  end

  describe "#copy" do
    it "copies file to file" do
      input_path = temp_dir.join "input.txt"
      input_path.write "This is a test."
      output_path = temp_dir.join "output.txt"
      input_path.copy output_path

      expect(output_path.read).to eq("This is a test.")
    end

    it "copies file to directory" do
      input_path = temp_dir.join "input.txt"
      input_path.write "This is a test."
      output_path = temp_dir.join "output"
      output_path.mkpath
      input_path.copy output_path

      expect(output_path.join("input.txt").read).to eq("This is a test.")
    end

    it "answers self" do
      input_path = temp_dir.join("input.txt").touch
      output_path = temp_dir.join "output.txt"

      expect(input_path.copy(output_path)).to eq(input_path)
    end

    it "fails to copy file to non-existent directory" do
      input_path = temp_dir.join("input.txt").touch
      output_path = temp_dir.join "output/test.txt"
      copy = -> { input_path.copy output_path }

      expect(&copy).to raise_error(Errno::ENOENT, /No.+file\sor\sdirectory.+output/)
    end

    it "fails to copy directory" do
      input_path = temp_dir.join "input"
      output_path = temp_dir.join "output"
      output_path.mkpath
      copy = -> { input_path.copy output_path }

      expect(&copy).to raise_error(Errno::ENOENT, /No.+file\sor\sdirectory.+input/)
    end
  end

  describe "#rewrite" do
    let(:test_path) { temp_dir.join "test.txt" }

    before { test_path.write "This is a [text]." }

    it "reads and writes file" do
      test_path.rewrite { |content| content.sub "[text]", "test" }
      expect(test_path.read).to eq("This is a test.")
    end

    it "does nothing without a block" do
      test_path.rewrite
      expect(test_path.read).to eq("This is a [text].")
    end

    it "answers self" do
      rewrite = test_path.rewrite { "Test." }
      expect(rewrite).to eq(test_path)
    end
  end

  describe "touch" do
    let(:test_path) { temp_dir.join "test.txt" }

    context "with existing file" do
      before { test_path.write "This is a test." }

      it "updates accessed time with current time" do
        original = test_path.atime
        test_path.touch

        expect(test_path.atime).to be > original
      end

      it "updates accessed time with custom time" do
        original = test_path.atime
        test_path.touch at: Time.now - 1

        expect(test_path.atime).to be < original
      end

      it "updates modified time with current time" do
        original = test_path.mtime
        test_path.touch

        expect(test_path.mtime).to be > original
      end

      it "updates modified time with custom time" do
        original = test_path.mtime
        test_path.touch at: Time.now - 1

        expect(test_path.mtime).to be < original
      end

      it "answers self" do
        expect(test_path.touch).to eq(test_path)
      end
    end

    context "without existing file" do
      it "creates empty file" do
        test_path.touch
        expect(test_path.read).to eq("")
      end

      it "answers self" do
        expect(test_path.touch).to eq(test_path)
      end
    end
  end
end
