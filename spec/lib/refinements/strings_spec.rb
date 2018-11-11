# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Strings do
  using Refinements::Strings

  describe "#first" do
    subject(:strings) { "seedlings" }

    it "answers first letter" do
      expect(strings.first).to eq("s")
    end

    it "answers first letters with positive number" do
      expect(strings.first(3)).to eq("see")
    end

    it "answers empty string with negative number" do
      expect(strings.first(-1)).to eq("")
    end

    it "answers itself when empty" do
      expect("".first).to eq("")
    end

    it "fails with type error when unable to cast number to integer" do
      result = -> { strings.first :bogus }
      expect(&result).to raise_error(TypeError, "can't convert Symbol into Integer")
    end
  end

  describe "#last" do
    subject(:strings) { "weather" }

    it "answers last letter" do
      expect(strings.last).to eq("r")
    end

    it "answers last letters with positive number" do
      expect(strings.last(3)).to eq("her")
    end

    it "answers empty string with negative number" do
      expect(strings.last(-1)).to eq("")
    end

    it "answers itself when empty" do
      expect("".last).to eq("")
    end

    it "fails with type error when unable to cast number to integer" do
      result = -> { strings.last :bogus }
      expect(&result).to raise_error(TypeError, "can't convert Symbol into Integer")
    end
  end

  describe "#blank?" do
    it "answers true when empty" do
      expect("".blank?).to eq(true)
    end

    it "answers true when space" do
      expect(" ".blank?).to eq(true)
    end

    it "answers true when tab" do
      expect("\t".blank?).to eq(true)
    end

    it "answers true when new line" do
      expect("\n".blank?).to eq(true)
    end

    it "answers true when return" do
      expect("\r".blank?).to eq(true)
    end

    it "answers true when space, tab, new line, and return" do
      expect(" \t\n\r".blank?).to eq(true)
    end

    it "answers false when a word" do
      expect("test".blank?).to eq(false)
    end

    it "answers false when a word" do
      expect("test".blank?).to eq(false)
    end

    it "answers false when a word, space, tab, new line, and return" do
      expect("test \t\n\r".blank?).to eq(false)
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

  describe "#down" do
    it "answers empty string as empty string" do
      expect("".down).to eq("")
    end

    it "downcases first letter only" do
      expect("TEST".down).to eq("tEST")
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
end
