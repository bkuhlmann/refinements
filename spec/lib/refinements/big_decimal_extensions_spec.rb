require "spec_helper"

RSpec.describe Refinements::BigDecimalExtensions do
  using Refinements::BigDecimalExtensions
  subject { BigDecimal.new "1.0E-15" }

  describe "#inspect" do
    it "answers object ID" do
      expect(subject.inspect).to match(/<BigDecimal:[a-f0-9].+\s.+/)
    end

    it "answers numeric representation" do
      expect(subject.inspect).to match(/0.000000000000001>/)
    end
  end
end
