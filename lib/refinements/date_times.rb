# frozen_string_literal: true

require "date"

module Refinements
  module DateTimes
    refine DateTime.singleton_class do
      def utc = now.new_offset(0)
    end
  end
end
