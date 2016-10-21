# frozen_string_literal: true

require "spec_helper"
require "refinements/string_extensions"

RSpec.describe Refinements::StringExtensions do
  using Refinements::StringExtensions

  describe "#cap" do
    it "answers empty string as empty string" do
      expect("".cap).to eq("")
    end

    it "capitalizes first letter only" do
      expect("test".cap).to eq("Test")
    end

    it "does not downcase remaining characters" do
      expect("TEST".cap).to eq("TEST")
    end
  end

  describe "#camelcase" do
    it "answer empty string for empty string" do
      expect("".camelcase).to eq("")
    end

    it "answers camelcase for camelcase" do
      expect("ThisIsATest".camelcase).to eq("ThisIsATest")
    end

    it "answers capitalized for downcase" do
      expect("test".camelcase).to eq("Test")
    end

    it "answers capitalized for capitalized" do
      expect("Test".camelcase).to eq("Test")
    end

    it "answers upcase as capitalized" do
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
      expect("This---is__a5   Test9".camelcase).to eq("ThisIsATest")
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
