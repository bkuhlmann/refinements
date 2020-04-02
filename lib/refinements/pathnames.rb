# frozen_string_literal: true

require "pathname"

module Refinements
  module Pathnames
    refine Pathname do
      def name
        basename extname
      end

      def copy to
        destination = to.directory? ? to.join(basename) : to
        read.then { |content| destination.write content }
        self
      end

      def relative_parent_from root
        relative_path_from(root).parent
      end

      def make_ancestors
        dirname.mkpath
        self
      end

      def rewrite
        read.then { |content| write yield(content) if block_given? }
        self
      end

      def touch at: Time.now
        exist? ? utime(at, at) : write("")
        self
      end
    end
  end
end
