# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Pathnames do
  include_context "with temporary directory"

  using described_class

  describe "#Pathname" do
    it "answers blank pathname for nil" do
      expect(Pathname(nil)).to eq(Pathname(""))
    end

    it "answers pathname for string" do
      expect(Pathname("/tmp")).to eq(Pathname.new("/tmp"))
    end

    it "answers pathname for pathname" do
      expect(Pathname(temp_dir)).to eq(temp_dir)
    end
  end

  describe ".home" do
    it "answes user home directory" do
      expect(Pathname.home).to eq(Pathname(ENV["HOME"]))
    end
  end

  describe ".make_temp_dir" do
    it "answers temporary directory as Pathname without block" do
      example_dir = Pathname.make_temp_dir
      expect(example_dir).to be_a(Pathname)
    ensure
      example_dir.remove_dir
    end

    it "answers default temporary directory without block" do
      example_dir = Pathname.make_temp_dir
      expect(example_dir.to_s).to match(/temp-.*\Z/)
    ensure
      example_dir.remove_dir
    end

    it "answers prefixed temporary directory without block" do
      example_dir = Pathname.make_temp_dir prefix: "prefix-"
      expect(example_dir.to_s).to match(/prefix-.*\Z/)
    ensure
      example_dir.remove_dir
    end

    it "answers suffixed temporary directory without block" do
      example_dir = Pathname.make_temp_dir suffix: "-suffix"
      expect(example_dir.to_s).to match(/-suffix\Z/)
    ensure
      example_dir.remove_dir
    end

    it "answers prefixed and suffixed temporary directory without block" do
      example_dir = Pathname.make_temp_dir prefix: "prefix-", suffix: "-suffix"
      expect(example_dir.to_s).to match(/prefix-.*-suffix\Z/)
    ensure
      example_dir.remove_dir
    end

    it "answers custom temporary directory root without block" do
      example_dir = Pathname.make_temp_dir root: temp_dir
      expect(example_dir.to_s).to match(%r(#{temp_dir}/temp-.*))
    ensure
      example_dir.remove_dir
    end

    it "yields pathname with block" do
      example_dir = Pathname.make_temp_dir { |path| path }
      expect(example_dir).to be_a(Pathname)
    end

    it "answers block result with block" do
      sub_dir = Pathname.make_temp_dir { |path| path.join("sub_dir").to_s }
      expect(sub_dir).to match(%r(temp-.*/sub_dir\Z))
    end
  end

  describe ".require_tree" do
    let(:requirement_a) { temp_dir.join("a.rb").write "# Test A" }
    let(:requirement_b) { temp_dir.join("nested").make_dir.join("b.rb").write "# Test B" }
    let(:tree) { $LOADED_FEATURES.select { |path| path.match? %r(/(a|b).rb\Z) } }

    before { [requirement_a, requirement_b].each { |path| $LOADED_FEATURES.delete path.to_s } }

    it "requires all by default" do
      Pathname.require_tree temp_dir
      expect(tree).to contain_exactly(requirement_a.to_s, requirement_b.to_s)
    end

    it "requires files with custom pattern" do
      Pathname.require_tree temp_dir, "./*.rb"
      expect(tree).to contain_exactly(requirement_a.to_s)
    end
  end

  describe ".root" do
    it "answers root path" do
      expect(Pathname.root).to eq(Pathname("/"))
    end
  end

  describe "#change_dir" do
    context "without block" do
      around do |example|
        original_path = Pathname.pwd
        example.run
        Dir.chdir original_path
      end

      it "changes to directory of current path" do
        temp_dir.change_dir
        expect(Pathname.pwd).to eq(temp_dir)
      end

      it "answers itself" do
        expect(temp_dir.change_dir).to eq(temp_dir)
      end
    end

    context "with block" do
      it "changes to directory of current path and yields" do
        temp_dir.change_dir { expect(Pathname.pwd).to eq(temp_dir) }
      end

      it "answers result of block" do
        result = temp_dir.change_dir { "test" }
        expect(result).to eq("test")
      end
    end

    it "fails when changing to non-existent directory" do
      expectation = -> { temp_dir.join("test").change_dir }
      expect(&expectation).to raise_error(Errno::ENOENT, /no.+directory.+test/i)
    end

    it "fails when changing to a file" do
      expectation = -> { temp_dir.join("test.txt").touch.change_dir }
      expect(&expectation).to raise_error(Errno::ENOTDIR, /not a directory.+test.txt/i)
    end
  end

  describe "#copy" do
    it "copies file to file" do
      input_path = temp_dir.join "input.txt"
      input_path.write "This is a test."
      output_path = temp_dir.join "output.txt"
      input_path.copy output_path

      expect(output_path.read).to eq("This is a test.")
    end

    it "copies file to directory" do
      input_path = temp_dir.join "input.txt"
      input_path.write "This is a test."
      output_path = temp_dir.join "output"
      output_path.mkpath
      input_path.copy output_path

      expect(output_path.join("input.txt").read).to eq("This is a test.")
    end

    it "answers self" do
      input_path = temp_dir.join("input.txt").touch
      output_path = temp_dir.join "output.txt"

      expect(input_path.copy(output_path)).to eq(input_path)
    end

    it "fails to copy file to non-existent directory" do
      input_path = temp_dir.join("input.txt").touch
      output_path = temp_dir.join "output/test.txt"
      copy = -> { input_path.copy output_path }

      expect(&copy).to raise_error(Errno::ENOENT, /No.+file\sor\sdirectory.+output/)
    end

    it "fails to copy directory" do
      input_path = temp_dir.join "input"
      output_path = temp_dir.join "output"
      output_path.mkpath
      copy = -> { input_path.copy output_path }

      expect(&copy).to raise_error(Errno::ENOENT, /No.+file\sor\sdirectory.+input/)
    end
  end

  describe "#directories" do
    it "answers only directories when mixed with directories and files" do
      a = temp_dir.join("a").tap(&:mkdir)
      temp_dir.join("a.txt").tap(&:touch)

      expect(temp_dir.directories).to contain_exactly(a)
    end

    it "answers filtered directories" do
      a = temp_dir.join("a").tap(&:mkdir)
      temp_dir.join("b").tap(&:mkdir)

      expect(temp_dir.directories("a*")).to contain_exactly(a)
    end

    it "answers sorted directories" do
      a = temp_dir.join("a").tap(&:mkdir)
      b = temp_dir.join("b").tap(&:mkdir)
      c = temp_dir.join("c").tap(&:mkdir)

      expect(temp_dir.directories).to eq([a, b, c])
    end

    it "answers flagged directories" do
      a = temp_dir.join(".test").tap(&:mkdir)

      expect(temp_dir.directories(flag: File::FNM_DOTMATCH)).to eq(
        [
          temp_dir.join(".."),
          temp_dir.join("."),
          a
        ]
      )
    end

    it "answers empty array without directories" do
      expect(temp_dir.directories).to eq([])
    end
  end

  describe "#extensions" do
    it "answers single extension" do
      expect(Pathname("test.txt").extensions).to contain_exactly(".txt")
    end

    it "answers single extension with dot in absolute path" do
      expect(Pathname("/Users/guest/.cache/test.txt").extensions).to contain_exactly(".txt")
    end

    it "answers multiple extensions" do
      expect(Pathname("test.html.adoc").extensions).to contain_exactly(".html", ".adoc")
    end

    it "answers empty extensions" do
      expect(Pathname("test").extensions).to eq([])
    end
  end

  describe "#files" do
    it "answers only files when mixed with directories and files" do
      a = temp_dir.join("a.txt").tap(&:touch)
      temp_dir.join("a").mkdir

      expect(temp_dir.files).to contain_exactly(a)
    end

    it "answers filtered files" do
      a = temp_dir.join("a.txt").tap(&:touch)
      temp_dir.join("a.dot").tap(&:touch)

      expect(temp_dir.files("*.txt")).to contain_exactly(a)
    end

    it "answers sorted files" do
      a = temp_dir.join("a.txt").tap(&:touch)
      b = temp_dir.join("b.txt").tap(&:touch)
      c = temp_dir.join("c.txt").tap(&:touch)

      expect(temp_dir.files).to eq([a, b, c])
    end

    it "answers flagged files" do
      a = temp_dir.join(".test").tap(&:touch)
      expect(temp_dir.files(flag: File::FNM_DOTMATCH)).to eq([a])
    end

    it "answers empty array without files" do
      expect(temp_dir.files).to eq([])
    end
  end

  describe "#gsub" do
    it "answers path with pattern replaced once" do
      expect(Pathname("/%pattern%/path").gsub("%pattern%", "test")).to eq(Pathname("/test/path"))
    end

    it "answers path with pattern replaced multiple times" do
      expect(Pathname("/a/%pattern%/b/%pattern%/c/%pattern%").gsub("%pattern%", "test")).to eq(
        Pathname("/a/test/b/test/c/test")
      )
    end
  end

  describe "#make_ancestors" do
    context "when directory" do
      let(:path) { ancestors.join "three" }
      let(:ancestors) { temp_dir.join "one", "two" }

      it "creates ancestors" do
        path.make_ancestors
        expect(ancestors.exist?).to eq(true)
      end

      it "does not create descendant path" do
        path.make_ancestors
        expect(path.exist?).to eq(false)
      end
    end

    context "when file" do
      let(:path) { ancestors.join "three.txt" }
      let(:ancestors) { temp_dir.join "one", "two" }

      it "creates ancestors" do
        path.make_ancestors
        expect(ancestors.exist?).to eq(true)
      end

      it "does not create descendant path" do
        path.make_ancestors
        expect(path.exist?).to eq(false)
      end
    end

    it "answers itself" do
      path = temp_dir.join "one", "two", "three.txt"
      expect(path.make_ancestors).to eq(path)
    end
  end

  describe "#make_dir" do
    let(:path) { temp_dir.join "demo" }

    it "makes new directory" do
      path.make_dir
      expect(path.exist?).to eq(true)
    end

    it "answers itself when existing" do
      path.make_dir
      expect(path.make_dir).to eq(path)
    end

    it "answers itself when not existing" do
      expect(path.make_dir).to eq(path)
    end
  end

  describe "#make_path" do
    let(:path) { temp_dir.join "one", "two", "three" }

    it "creates parents when parents don't exist" do
      path.make_path
      expect(path.parent.exist?).to eq(true)
    end

    it "creates full path hierarchy when path doesn't exist" do
      path.make_path
      expect(path.exist?).to eq(true)
    end

    it "answers itself" do
      expect(path.make_path).to eq(path)
    end

    it "answers itself when created multiple times" do
      path.make_path.make_path
      expect(path.make_path.make_path).to eq(path)
    end
  end

  describe "#name" do
    it "answers name of file without extension" do
      path = Pathname "example.txt"
      expect(path.name).to eq(Pathname("example"))
    end

    it "answers empty string when empty string" do
      path = Pathname ""
      expect(path.name).to eq(Pathname(""))
    end
  end

  describe "#relative_parent" do
    it "answers relative path with absolute path" do
      expect(Pathname("/one/two/three").relative_parent("/one")).to eq(Pathname("two"))
    end

    it "answers relative path with relative path" do
      expect(Pathname("one/two/three").relative_parent("one")).to eq(Pathname("two"))
    end

    it "answers relative path with no defined parent" do
      expect(Pathname("one").relative_parent("one")).to eq(Pathname(".."))
    end

    it "answers relative path with empty path" do
      expect(Pathname("").relative_parent("")).to eq(Pathname(".."))
    end
  end

  describe "#remove_dir" do
    let(:path) { temp_dir.join "test" }

    it "removes exsiting directory" do
      path.make_dir.remove_dir
      expect(path.exist?).to eq(false)
    end

    it "answers itself after being removed" do
      path.make_dir
      expect(path.remove_dir).to eq(path)
    end

    it "answers itself when not existing" do
      expect(path.remove_dir).to eq(path)
    end

    it "answers itself when chained" do
      expect(path.remove_dir.remove_dir).to eq(path)
    end
  end

  describe "#remove_tree" do
    let(:parent_path) { temp_dir.join "one" }
    let(:child_path) { parent_path.join "two" }

    it "removes itself and children" do
      child_path.make_path
      parent_path.remove_tree

      expect(parent_path.exist?).to eq(false)
    end

    it "removes children only" do
      child_path.make_path
      child_path.remove_tree

      expect(parent_path.exist?).to eq(true)
    end

    it "answers itself after being removed" do
      child_path.make_path
      expect(parent_path.remove_tree).to eq(parent_path)
    end

    it "answers itself when not existing" do
      expect(parent_path.remove_tree).to eq(parent_path)
    end
  end

  describe "#rewrite" do
    let(:test_path) { temp_dir.join "test.txt" }

    before { test_path.write "This is a [text]." }

    it "reads and writes file" do
      test_path.rewrite { |content| content.sub "[text]", "test" }
      expect(test_path.read).to eq("This is a test.")
    end

    it "does nothing without a block" do
      test_path.rewrite
      expect(test_path.read).to eq("This is a [text].")
    end

    it "answers self" do
      rewrite = test_path.rewrite { "Test." }
      expect(rewrite).to eq(test_path)
    end
  end

  describe "touch" do
    let(:test_path) { temp_dir.join "test.txt" }

    context "with existing file" do
      before { test_path.write "This is a test." }

      it "updates accessed time with current time" do
        original = test_path.atime
        test_path.touch

        expect(test_path.atime).to be > original
      end

      it "updates accessed time with custom time" do
        original = test_path.atime
        test_path.touch Time.now - 1

        expect(test_path.atime).to be < original
      end

      it "updates modified time with current time" do
        original = test_path.mtime
        test_path.touch

        expect(test_path.mtime).to be > original
      end

      it "updates modified time with custom time" do
        original = test_path.mtime
        test_path.touch Time.now - 1

        expect(test_path.mtime).to be < original
      end

      it "answers self" do
        expect(test_path.touch).to eq(test_path)
      end
    end

    context "without existing file" do
      it "creates empty file" do
        test_path.touch
        expect(test_path.read).to eq("")
      end

      it "answers self" do
        expect(test_path.touch).to eq(test_path)
      end
    end
  end

  describe "#write" do
    let(:path) { temp_dir.join "test.txt" }

    it "uses offset" do
      path.write "test", offset: 1
      expect(path.read).to eq("\u0000test")
    end

    it "uses options" do
      expectation = proc { path.write "test", mode: "r" }
      expect(&expectation).to raise_error(Errno::ENOENT, /no such file/i)
    end

    it "answers self" do
      expect(path.write("test")).to eq(path)
    end
  end
end
