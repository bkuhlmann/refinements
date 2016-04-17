# frozen_string_literal: true

require "spec_helper"
require "refinements/string_extensions"

RSpec.describe Refinements::StringExtensions do
  using Refinements::StringExtensions

  describe "#camelcase" do
    it "answer an empty string with an empty string" do
      expect("".camelcase).to eq("")
    end

    it "answers camelcase with camelcase" do
      expect("ThisIsATest".camelcase).to eq("ThisIsATest")
    end

    it "downcases and capitalizes" do
      expect("TEST".camelcase).to eq("Test")
    end

    it "removes spaces" do
      expect("this is a test".camelcase).to eq("ThisIsATest")
    end

    it "removes underscores" do
      expect("this_is_a_test".camelcase).to eq("ThisIsATest")
    end

    it "removes dashes" do
      expect("this-is-a-test".camelcase).to eq("ThisIsATest")
    end

    it "removes repeating, non-alphabetic characters" do
      expect("This---is__a   Test".camelcase).to eq("ThisIsATest")
    end

    it "does not remove repeating, alphabetic characters" do
      expect("Thiiiis Is Aaaaa Testt".camelcase).to eq("ThiiiisIsAaaaaTestt")
    end
  end

  describe "#snakecase" do
    it "answer an empty string with an empty string" do
      expect("".snakecase).to eq("")
    end

    it "answers snakecase with snakecase" do
      expect("this_is_a_test".snakecase).to eq("this_is_a_test")
    end

    it "downcases" do
      expect("TEST".snakecase).to eq("test")
    end

    it "replaces spaces with underscores" do
      expect("this is a test".snakecase).to eq("this_is_a_test")
    end

    it "replaces dashes with underscores" do
      expect("this-is-a-test".snakecase).to eq("this_is_a_test")
    end

    it "removes repeating, non-alphabetic characters" do
      expect("This---is__a   Test".snakecase).to eq("this_is_a_test")
    end

    it "does not remove repeating, alphabetic characters" do
      expect("Thiiiis Is Aaaaa Testt".snakecase).to eq("thiiiis_is_aaaaa_testt")
    end
  end

  describe "#titleize" do
    it "answer an empty string with an empty string" do
      expect("".titleize).to eq("")
    end

    it "answers titleize with titleize" do
      expect("This Is A Test".titleize).to eq("This Is A Test")
    end

    it "capitalizes each word" do
      expect("this is a test".titleize).to eq("This Is A Test")
    end

    it "replaces underscores with spaces" do
      expect("this_is_a_test".titleize).to eq("This Is A Test")
    end

    it "replaces dashes with spaces" do
      expect("this-is-a-test".titleize).to eq("This Is A Test")
    end

    it "removes repeating, non-alphabetic characters" do
      expect("This---is__a   Test".titleize).to eq("This Is A Test")
    end

    it "does not remove repeating, alphabetic characters" do
      expect("Thiiiis Is Aaaaa Testt".titleize).to eq("Thiiiis Is Aaaaa Testt")
    end
  end
end
