# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::String do
  using described_class

  describe "#blank?" do
    it "answers true when empty" do
      expect("".blank?).to be(true)
    end

    it "answers true when space" do
      expect(" ".blank?).to be(true)
    end

    it "answers true when tab" do
      expect("\t".blank?).to be(true)
    end

    it "answers true when new line" do
      expect("\n".blank?).to be(true)
    end

    it "answers true when return" do
      expect("\r".blank?).to be(true)
    end

    it "answers true when space, tab, new line, and return" do
      expect(" \t\n\r".blank?).to be(true)
    end

    it "answers false when a word" do
      expect("test".blank?).to be(false)
    end

    it "answers false when a word, space, tab, new line, and return" do
      expect("test \t\n\r".blank?).to be(false)
    end
  end

  describe "#camelcase" do
    it "answers empty string as empty string" do
      expect("".camelcase).to eq("")
    end

    it "answers camelcase as camelcase" do
      expect("ThisIsATest".camelcase).to eq("ThisIsATest")
    end

    it "answers capitalized as capitalized" do
      expect("Test".camelcase).to eq("Test")
    end

    it "answers upcase as upcase" do
      expect("TEST".camelcase).to eq("TEST")
    end

    it "answers downcase as capitalized" do
      expect("test".camelcase).to eq("Test")
    end

    it "answers consecutive spaces as as empty string" do
      expect("   ".camelcase).to eq("")
    end

    it "answers consecutive underscores as empty string" do
      expect("___".camelcase).to eq("")
    end

    it "answers consecutive dashes as empty string" do
      expect("---".camelcase).to eq("")
    end

    it "answers consecutive slashes as empty string" do
      expect("///".camelcase).to eq("")
    end

    it "answers consecutive, odd colons as empty string" do
      expect(":::".camelcase).to eq("")
    end

    it "answers consecutive, even colons as empty string" do
      expect("::::".camelcase).to eq("")
    end

    it "answers space delimit as capitalized words delimited by nothing" do
      expect("this is a test".camelcase).to eq("ThisIsATest")
    end

    it "answers underscore delimit as capitalized words delimited by nothing" do
      expect("this_is_a_test".camelcase).to eq("ThisIsATest")
    end

    it "answers dash delimit as capitalized words delimited by double colons" do
      expect("this-is-a-test".camelcase).to eq("This::Is::A::Test")
    end

    it "answers slash delimit as capitalized words delimited by double colons" do
      expect("this/is/a/test".camelcase).to eq("This::Is::A::Test")
    end

    it "answers single colon delimit as capitalized words delimited by double colons" do
      expect("this:is:a:test".camelcase).to eq("This::Is::A::Test")
    end

    it "answers double colon delimit as capitalized words delimited by double colons" do
      expect("this::is::a::test".camelcase).to eq("This::Is::A::Test")
    end

    it "answers multi-space delimit as capitalized words delimited by nothing" do
      expect("example   test".camelcase).to eq("ExampleTest")
    end

    it "answers spaced, underscore delimit as capitalized words delimited by nothing" do
      expect("example _ test".camelcase).to eq("ExampleTest")
    end

    it "answers spaced, dash delimit as capitalized words delimited by double colon" do
      expect("example - test".camelcase).to eq("Example::Test")
    end

    it "answers spaced, slash delimit as capitalized words delimited by double colon" do
      expect("example / test".camelcase).to eq("Example::Test")
    end

    it "answers spaced, single colon delimit as capitalized words delimited by double colon" do
      expect("example : test".camelcase).to eq("Example::Test")
    end

    it "answers spaced, double colon delimit as capitalized words delimited by double colon" do
      expect("example :: test".camelcase).to eq("Example::Test")
    end

    it "transforms mixed space, underscore, dash, slash, colon, and double colon delimiters" do
      expect("this is_a-mixed/test:case::example".camelcase).to eq(
        "ThisIsA::Mixed::Test::Case::Example"
      )
    end
  end

  describe "#down" do
    it "answers empty string as empty string" do
      expect("".down).to eq("")
    end

    it "downcases first letter only" do
      expect("TEST".down).to eq("tEST")
    end
  end

  describe "#falsey?" do
    %w[true yes on t y 1].each do |value|
      it %(answers false with "#{value}") do
        expect(value.falsey?).to be(false)
      end
    end
  end

  describe "#first" do
    subject(:string) { "seedlings" }

    it "answers first letter" do
      expect(string.first).to eq("s")
    end

    it "answers first letters with positive number" do
      expect(string.first(3)).to eq("see")
    end

    it "answers empty string with negative number" do
      expect(string.first(-1)).to eq("")
    end

    it "answers itself when empty" do
      expect("".first).to eq("")
    end
  end

  describe "#indent" do
    it "answers two space indentation by default" do
      expect("test".indent).to eq("  test")
    end

    it "answers self with zero multiplier" do
      expect("test".indent(0)).to eq("test")
    end

    it "answers self with negative multiplier" do
      expect("test".indent(-1)).to eq("test")
    end

    it "answers indentation with custom multiplier" do
      expect("test".indent(3)).to eq("      test")
    end

    it "answers indentation with custom padding" do
      expect("test".indent(pad: " ")).to eq(" test")
    end

    it "answers indentation with custom multiplier and padding" do
      expect("test".indent(2, pad: " ")).to eq("  test")
    end
  end

  describe "#last" do
    subject(:string) { "weather" }

    it "answers last letter" do
      expect(string.last).to eq("r")
    end

    it "answers last letters with positive number" do
      expect(string.last(3)).to eq("her")
    end

    it "answers empty string with negative number" do
      expect(string.last(-1)).to eq("")
    end

    it "answers itself when empty" do
      expect("".last).to eq("")
    end
  end

  describe "#pluralize" do
    it "answers plural by default" do
      expect("apple".pluralize("s")).to eq("apples")
    end

    it "answers plural with zero count" do
      expect("apple".pluralize("s", 0)).to eq("apples")
    end

    it "answers plural with count greater than one" do
      expect("apple".pluralize("s", 2)).to eq("apples")
    end

    it "answers plural with count less than one" do
      expect("apple".pluralize("s", -2)).to eq("apples")
    end

    it "answers singular with positive count of one" do
      expect("apple".pluralize("s", 1)).to eq("apple")
    end

    it "ansers singular with negative count of one" do
      expect("apple".pluralize("s", -1)).to eq("apple")
    end

    it "answers plural with suffix replacement" do
      expect("cactus".pluralize("i", replace: "us")).to eq("cacti")
    end

    it "answers plural with body replacement" do
      expect("cul-de-sac".pluralize("ls", replace: "l")).to eq("culs-de-sac")
    end
  end

  describe "#singularize" do
    it "answers singular by default" do
      expect("apples".singularize("s")).to eq("apple")
    end

    it "answers singular with regular expession" do
      expect("sacks".singularize(/s$/)).to eq("sack")
    end

    it "answers singular with positive count of one" do
      expect("apples".singularize("s", 1)).to eq("apple")
    end

    it "answers singular with negative count of one" do
      expect("apples".singularize("s", -1)).to eq("apple")
    end

    it "answers plural with zero count" do
      expect("apples".singularize("s", 0)).to eq("apples")
    end

    it "answers plural with count greater than one" do
      expect("apples".singularize("s", 2)).to eq("apples")
    end

    it "answers plural with count less than one" do
      expect("apples".singularize("s", -2)).to eq("apples")
    end

    it "answers singular with simple replacement" do
      expect("cacti".singularize("i", replace: "us")).to eq("cactus")
    end

    it "answers singular with body replacement" do
      expect("culs-de-sac".singularize("ls", replace: "l")).to eq("cul-de-sac")
    end
  end

  describe "#snakecase" do
    it "answers empty string as empty string" do
      expect("".snakecase).to eq("")
    end

    it "answers upcase as downcase" do
      expect("TEST".snakecase).to eq("test")
    end

    it "answers camelcase as snakecase" do
      expect("ExampleTest".snakecase).to eq("example_test")
    end

    it "answers consecutive spaces as empty string" do
      expect("   ".snakecase).to eq("")
    end

    it "answers consecutive underscores as empty string" do
      expect("___".snakecase).to eq("")
    end

    it "answers consecutive dashes as empty string" do
      expect("---".snakecase).to eq("")
    end

    it "answers consecutive slashes as empty string" do
      expect("///".snakecase).to eq("")
    end

    it "answers consecutive, odd colons as empty string" do
      expect(":::".snakecase).to eq("")
    end

    it "answers consecutive, even colons as empty string" do
      expect("::::".snakecase).to eq("")
    end

    it "answers space delimit as downcased words delimited by underscores" do
      expect("This Is a Test".snakecase).to eq("this_is_a_test")
    end

    it "answers underscore delimit as downcased words delimited by underscores" do
      expect("This_Is_A_Test".snakecase).to eq("this_is_a_test")
    end

    it "answers dash delimit as downcased words delimited by slashes" do
      expect("This-Is-A-Test".snakecase).to eq("this/is/a/test")
    end

    it "answers slash delimit as downcased words delimited by slashes" do
      expect("This/Is/A/Test".snakecase).to eq("this/is/a/test")
    end

    it "answers single colon delimit as downcased words delimited by slashes" do
      expect("This:Is:A:Test".snakecase).to eq("this/is/a/test")
    end

    it "answers double colon delimit as downcased words delimited by slashes" do
      expect("This::Is::A::Test".snakecase).to eq("this/is/a/test")
    end

    it "answers multi-space delimit as downcased words delimited by underscore" do
      expect("Example   Test".snakecase).to eq("example_test")
    end

    it "answers spaced, underscore delimit as downcased words delimited by underscore" do
      expect("Example _ Test".snakecase).to eq("example_test")
    end

    it "answers spaced, dash delimit as downcased words delimited by slash" do
      expect("Example - Test".snakecase).to eq("example/test")
    end

    it "answers spaced, slash delimit as downcased words delimited by slash" do
      expect("Example / Test".snakecase).to eq("example/test")
    end

    it "answers spaced, single colon delimit as downcased words delimited by slash" do
      expect("Example : Test".snakecase).to eq("example/test")
    end

    it "answers spaced, double colon delimit as downcased words delimited by slash" do
      expect("Example :: Test".snakecase).to eq("example/test")
    end

    it "transforms mixed space, underscore, dash, slash, colon, and double colon delimiters" do
      expect("This Is_A-Mixed/Test:Case::Example".snakecase).to eq(
        "this_is_a/mixed/test/case/example"
      )
    end
  end

  describe "#squish" do
    it "answers string with leading, body, and trailing whitespace removed" do
      expect(" one  two   \n    \t   three ".squish).to eq("one two three")
    end

    it "answers itself when nothing to do" do
      text = "one two three"
      expect(text.squish).to eq(text)
    end

    it "doesn't mutate itself" do
      text = " one \n\t two "
      text.squish

      expect(text).to eq(" one \n\t two ")
    end
  end

  describe "#titleize" do
    it "answers empty string as empty string" do
      expect("".titleize).to eq("")
    end

    it "answers titleize as titleize" do
      expect("This Is A Test".titleize).to eq("This Is A Test")
    end

    it "answers camelcase as titleize" do
      expect("ThisIsATest".titleize).to eq("This Is A Test")
    end

    it "answers upcase with first letter capitalized and remaining characters downcased" do
      expect("TEST".titleize).to eq("Test")
    end

    it "answers consecutive spaces as empty string" do
      expect("   ".titleize).to eq("")
    end

    it "answers consecutive underscores as empty string" do
      expect("___".titleize).to eq("")
    end

    it "answers consecutive dashes as empty string" do
      expect("---".titleize).to eq("")
    end

    it "answers consecutive slashes as empty string" do
      expect("///".titleize).to eq("")
    end

    it "answers consecutive, odd colons as empty string" do
      expect(":::".titleize).to eq("")
    end

    it "answers consecutive, even colons as empty string" do
      expect("::::".titleize).to eq("")
    end

    it "answers space delimit as capitalized words delimited by spaces" do
      expect("this is a test".titleize).to eq("This Is A Test")
    end

    it "answers underscore delimit as capitalized words delimited by spaces" do
      expect("this_is_a_test".titleize).to eq("This Is A Test")
    end

    it "answers dash delimit as capitalized words delimited by spaces" do
      expect("this-is-a-test".titleize).to eq("This Is A Test")
    end

    it "answers slash delimit as capitalized words delimited by slashes" do
      expect("this/is/a/test".titleize).to eq("This/Is/A/Test")
    end

    it "answers single colon delimit as capitalized words delimited by slashes" do
      expect("this:is:a:test".titleize).to eq("This/Is/A/Test")
    end

    it "answers double colon delimit as capitalized words delimited by slashes" do
      expect("this::is::a::test".titleize).to eq("This/Is/A/Test")
    end

    it "answers multi-spaced delimit as capitalized words delimited by space" do
      expect("example   test".titleize).to eq("Example Test")
    end

    it "answers spaced, underscore delimit as capitalized words delimited by space" do
      expect("example _ test".titleize).to eq("Example Test")
    end

    it "answers spaced, dash delimit as capitalized words delimited by space" do
      expect("example - test".titleize).to eq("Example Test")
    end

    it "answers spaced, slash delimit as capitalized words delimited by slash" do
      expect("example / test".titleize).to eq("Example/Test")
    end

    it "answers spaced, single colon delimit as capitalized words delimited by slash" do
      expect("example : test".titleize).to eq("Example/Test")
    end

    it "answers spaced, double colon delimit as capitalized words delimited by slash" do
      expect("example :: test".titleize).to eq("Example/Test")
    end

    it "transforms mixed space, underscore, dash, slash, colon, and double colon delimiters" do
      expect("this is_a-mixed/test:case::example".titleize).to eq(
        "This Is A Mixed/Test/Case/Example"
      )
    end
  end

  describe "#truthy?" do
    %w[true yes on t y 1].each do |value|
      it %(answers true with "#{value}") do
        expect(value.truthy?).to be(true)
      end
    end

    it "answers true when surrounded by empty spaces" do
      expect(" yes  ".truthy?).to be(true)
    end

    it "answers true with mixed case" do
      expect("TrUe".truthy?).to be(true)
    end

    it "answers false with empty string" do
      expect("".truthy?).to be(false)
    end

    it "answers false with invalid value" do
      expect("bogus".truthy?).to be(false)
    end
  end

  describe "#truncate" do
    let(:string) { "This is a test example." }
    let(:length) { string.length }

    it "answers string with length at word break" do
      expect(string.truncate(10)).to eq("This is...")
    end

    it "answers string with length in middle of word" do
      expect(string.truncate(15)).to eq("This is a te...")
    end

    it "answers full string when length is equal to string length" do
      expect(string.truncate(length)).to eq("This is a test example.")
    end

    it "answers full string when length is larger than string length" do
      expect(string.truncate(Float::INFINITY)).to eq("This is a test example.")
    end

    it "answers string with string delimiter" do
      expect(string.truncate(15, " ")).to eq("This is a...")
    end

    it "answers string with regular expression delimiter" do
      expect(string.truncate(15, /\s/)).to eq("This is a...")
    end

    it "answers string with custom trailer" do
      expect(string.truncate(17, trailer: "... (more)")).to eq("This is... (more)")
    end

    it "answers string with no trailer" do
      expect(string.truncate(7, trailer: "")).to eq("This is")
    end

    it "answers overflow when string length is smaller than truncation length" do
      expect("test".truncate(3)).to eq("...")
    end

    it "doesn't mutate original string" do
      string.truncate 10
      expect(string).to eq("This is a test example.")
    end
  end

  describe "#to_bool" do
    it "prints deprecation warning" do
      expectation = proc { "yes".to_bool }
      message = "`String#to_bool` is deprecated, use `#truthy?` or `#falsey?` instead.\n"

      expect(&expectation).to output(message).to_stderr
    end

    %w[true yes on t y 1].each do |value|
      it %(answers true with "#{value}") do
        expect(value.to_bool).to be(true)
      end
    end

    it "answers true when surrounded by empty spaces" do
      expect(" yes  ".to_bool).to be(true)
    end

    it "answers true with mixed case" do
      expect("TrUe".to_bool).to be(true)
    end

    it "answers false with empty string" do
      expect("".to_bool).to be(false)
    end

    it "answers false with invalid value" do
      expect("bogus".to_bool).to be(false)
    end
  end

  describe "#up" do
    it "answers empty string as empty string" do
      expect("".up).to eq("")
    end

    it "upcases first letter only" do
      expect("test".up).to eq("Test")
    end
  end
end
