# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Time do
  using described_class

  describe "#rfc_3339" do
    let(:format) { /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(-|\+)\d{2}:\d{2}/ }

    it "answers RFC 3339 format with local timezone" do
      expect(Time.now.rfc_3339).to match(format)
    end

    it "answers RFC 3339 format with UTC timezone" do
      expect(Time.now.utc.rfc_3339).to match(format)
    end
  end
end
