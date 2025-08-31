# frozen_string_literal: true

require "pathname"

module Refinements
  # Provides additional enhancements to the Pathname primitive.
  module Pathname
    refine Kernel do
      def Pathname object
        return super(String(object)) unless object

        super
      end
    end

    refine ::Pathname.singleton_class do
      def home = new ENV.fetch("HOME", "")

      def require_tree(root) = new(root).files("**/*.rb").each { |path| require path.to_s }

      def root = new(File::SEPARATOR)
    end

    refine ::Pathname do
      def change_dir
        if block_given?
          Dir.chdir(self) { |path| yield Pathname(path) }
        else
          Dir.chdir self and self
        end
      end

      def clear = children.each(&:rmtree) && self

      def copy to
        destination = to.directory? ? to.join(basename) : to
        ::IO.copy_stream self, destination
        self
      end

      def deep_touch(...)
        warn "`#{self.class}##{__method__}` is deprecated, use `#touch_deep` instead.",
             category: :deprecated

        touch_deep(...)
      end

      def delete = super && self

      def delete_prefix(pattern) = parent.join %(#{name.sub(/\A#{pattern}/, "")}#{extname})

      def delete_suffix(pattern) = parent.join %(#{name.sub(/#{pattern}\z/, "")}#{extname})

      def directories pattern = "*", flag: File::FNM_SYSCASE
        glob(pattern, flag).select(&:directory?)
      end

      def empty = file? ? (truncate(0) and self) : rmtree.make_dir

      def extensions = basename.to_s.split(/(?=\.)+/).tap(&:shift)

      def files(pattern = "*", flag: File::FNM_SYSCASE) = glob(pattern, flag).select(&:file?)

      def gsub(pattern, replacement) = self.class.new(to_s.gsub(pattern, replacement))

      def make_ancestors
        dirname.mkpath
        self
      end

      def make_dir = exist? ? self : (mkdir and self)

      def name = basename extname

      def puts(content) = write "#{content}\n"

      def relative_parent(root_dir) = relative_path_from(root_dir).parent

      def remove_dir = exist? ? (rmdir and self) : self

      def rewrite = read.then { |content| write yield(content) if block_given? }

      def touch at = Time.now
        exist? ? utime(at, at) : write("")
        self
      end

      def touch_deep(...) = make_ancestors.touch(...)

      def write content, offset: nil, **options
        super content, offset, **options
        self
      end
    end
  end
end
