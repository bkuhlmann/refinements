# frozen_string_literal: true

require "pathname"

module Refinements
  module Pathnames
    refine Kernel do
      def Pathname object
        return super(String(object)) unless object

        super
      end
    end

    refine Pathname do
      def name
        basename extname
      end

      def change_dir &block
        Dir.chdir(self, &block)
        self
      end

      def copy to
        destination = to.directory? ? to.join(basename) : to
        read.then { |content| destination.write content }
        self
      end

      def directories pattern = "*", flag: File::FNM_SYSCASE
        glob(pattern, flag).select(&:directory?).sort
      end

      def extensions
        basename.to_s.split(/(?=\.)+/).tap(&:shift)
      end

      def files pattern = "*", flag: File::FNM_SYSCASE
        glob(pattern, flag).select(&:file?).sort
      end

      def gsub pattern, replacement
        self.class.new to_s.gsub(pattern, replacement)
      end

      def relative_parent root_dir
        relative_path_from(root_dir).parent
      end

      def relative_parent_from root_dir
        warn "[DEPRECATION]: Pathname#relative_parent_from is deprecated, " \
             "use Pathname#relative_parent instead."
        relative_parent root_dir
      end

      def make_ancestors
        dirname.mkpath
        self
      end

      def make_dir
        exist? ? self : mkdir and self
      end

      def make_path
        mkpath
        self
      end

      def mkdir
        exist? ? self : super and self
      end

      def remove_dir
        exist? ? (rmdir and self) : self
      end

      def remove_tree
        rmtree if exist?
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
