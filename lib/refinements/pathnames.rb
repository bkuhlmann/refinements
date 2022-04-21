# frozen_string_literal: true

require "pathname"

module Refinements
  # Provides additional enhancements to the Pathname primitive.
  module Pathnames
    refine Kernel do
      def Pathname object
        return super(String(object)) unless object

        super
      end
    end

    refine Pathname.singleton_class do
      def home = new ENV.fetch("HOME", "")

      def make_temp_dir prefix: "temp-", suffix: nil, root: nil
        if block_given?
          Dir.mktmpdir([prefix, suffix], root) { |path| yield new(path) }
        else
          new Dir.mktmpdir([prefix, suffix], root)
        end
      end

      def require_tree root, pattern = "**/*.rb"
        new(root).files(pattern).each { |path| require path.to_s }
      end

      def root = new(File::SEPARATOR)
    end

    refine Pathname do
      def change_dir
        if block_given?
          Dir.chdir(self) { |path| yield Pathname(path) }
        else
          Dir.chdir self and self
        end
      end

      def copy to
        destination = to.directory? ? to.join(basename) : to
        read.then { |content| destination.write content }
        self
      end

      def deep_touch(...) = make_ancestors.touch(...)

      def delete = super && self

      def delete_prefix(pattern) = parent.join %(#{name.sub(/\A#{pattern}/, "")}#{extname})

      def delete_suffix(pattern) = parent.join %(#{name.sub(/#{pattern}\z/, "")}#{extname})

      def directories pattern = "*", flag: File::FNM_SYSCASE
        glob(pattern, flag).select(&:directory?).sort
      end

      def empty = file? ? (truncate(0) and self) : remove_tree.make_dir

      def extensions = basename.to_s.split(/(?=\.)+/).tap(&:shift)

      def files(pattern = "*", flag: File::FNM_SYSCASE) = glob(pattern, flag).select(&:file?).sort

      def gsub(pattern, replacement) = self.class.new(to_s.gsub(pattern, replacement))

      def make_ancestors
        dirname.mkpath
        self
      end

      def make_dir = exist? ? self : (mkdir and self)

      def make_path
        mkpath
        self
      end

      def name = basename extname

      def relative_parent(root_dir) = relative_path_from(root_dir).parent

      def remove_dir = exist? ? (rmdir and self) : self

      def remove_tree
        rmtree if exist?
        self
      end

      def rewrite = read.then { |content| write yield(content) if block_given? }

      def touch at = Time.now
        exist? ? utime(at, at) : write("")
        self
      end

      def write content, offset: nil, **options
        super content, offset, **options
        self
      end
    end
  end
end
