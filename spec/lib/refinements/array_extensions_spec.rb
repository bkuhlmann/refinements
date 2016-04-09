# frozen_string_literal: true

require "spec_helper"
require "refinements/array_extensions"

RSpec.describe Refinements::ArrayExtensions do
  using Refinements::ArrayExtensions

  describe "#compress" do
    it "answers original array when nothing to do" do
      subject = %w[one two]
      expect(subject.compress).to contain_exactly("one", "two")
    end

    it "answers array with nils removed" do
      subject = ["one", nil, "two"]
      expect(subject.compress).to contain_exactly("one", "two")
    end

    it "answers array with blank strings removed" do
      subject = ["one", "", "two"]
      expect(subject.compress).to contain_exactly("one", "two")
    end

    it "does not modify original values" do
      subject = ["one", nil, "", "two"]
      subject.compress

      expect(subject).to contain_exactly("one", nil, "", "two")
    end
  end

  describe "#compress!" do
    it "answers original array when nothing to do" do
      subject = %w[one two]
      expect(subject.compress!).to contain_exactly("one", "two")
    end

    it "answers array with nils removed" do
      subject = ["one", nil, "two"]
      expect(subject.compress!).to contain_exactly("one", "two")
    end

    it "answers array with empty values removed" do
      subject = ["one", "", "two"]
      expect(subject.compress!).to contain_exactly("one", "two")
    end

    it "modifies original values" do
      subject = ["one", nil, "", "two"]
      subject.compress!

      expect(subject).to contain_exactly("one", "two")
    end
  end
end
