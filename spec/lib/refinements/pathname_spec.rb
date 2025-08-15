# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Pathname do
  include_context "with temporary directory"

  using described_class

  shared_examples "a touchable path" do
    it "updates accessed time with current time" do
      original = path.atime
      path.touch

      expect(path.atime).to be > original
    end

    it "updates accessed time with custom time" do
      original = path.atime
      path.touch Time.now - 1

      expect(path.atime).to be < original
    end

    it "updates modified time with current time" do
      original = path.mtime
      path.touch

      expect(path.mtime).to be > original
    end

    it "updates modified time with custom time" do
      original = path.mtime
      path.touch Time.now - 1

      expect(path.mtime).to be < original
    end

    it "answers self" do
      expect(path.touch).to eq(path)
    end
  end

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
      expect(Pathname.home).to eq(Pathname(Dir.home))
    end
  end

  describe ".require_tree" do
    let(:one) { temp_dir.join("a.rb").write "# Test A" }
    let(:two) { temp_dir.join("nested").make_dir.join("b.rb").write "# Test B" }
    let(:tree) { $LOADED_FEATURES.grep %r(/(a|b).rb\Z) }

    before { [one, two].each { |path| $LOADED_FEATURES.delete path.to_s } }

    it "requires all files" do
      Pathname.require_tree temp_dir
      expect(tree).to contain_exactly(one.to_s, two.to_s)
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
      it "changes to directory of current path and yields no argument" do
        temp_dir.change_dir { expect(Pathname.pwd).to eq(temp_dir) }
      end

      it "changes to directory of current path and yields argument" do
        temp_dir.change_dir { |path| expect(path).to eq(temp_dir) }
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

  describe "#clear" do
    it "removes all directories and files" do
      temp_dir.join("one.txt").touch
      temp_dir.join("nested/two.txt").deep_touch
      temp_dir.clear

      expect(temp_dir.children).to eq([])
    end

    it "answers itself" do
      expect(temp_dir.clear).to eq(temp_dir)
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

  describe "#deep_touch" do
    subject(:path) { temp_dir.join("a/b/c/d.txt").deep_touch }

    it_behaves_like "a touchable path"

    it "creates nested file path" do
      expect(path.exist?).to be(true)
    end
  end

  describe "#delete" do
    subject(:path) { temp_dir.join "test.txt" }

    it "deletes existing file" do
      path.touch.delete
      expect(path.exist?).to be(false)
    end

    it "deletes existing directory" do
      temp_dir.delete
      expect(temp_dir.exist?).to be(false)
    end

    it "answers deleted path" do
      expect(path.touch.delete).to eq(path)
    end

    it "errors when attempting to delete path that doesn't exist" do
      expectation = proc { path.delete }
      expect(&expectation).to raise_error(Errno::ENOENT, /no such file or directory/i)
    end
  end

  describe "#delete_prefix" do
    it "removes file prefix" do
      expect(Pathname("x-test.rb").delete_prefix("x-")).to eq(Pathname("test.rb"))
    end

    it "removes path prefix" do
      expect(Pathname("a/path/x-test.rb").delete_prefix("x-")).to eq(Pathname("a/path/test.rb"))
    end

    it "answers original path when pattern doesn't match" do
      expect(Pathname("test.rb").delete_prefix("mismatch")).to eq(Pathname("test.rb"))
    end
  end

  describe "#delete_suffix" do
    it "removes file suffix" do
      expect(Pathname("test-x.rb").delete_suffix("-x")).to eq(Pathname("test.rb"))
    end

    it "removes path suffix" do
      expect(Pathname("a/path/test-x.rb").delete_suffix("-x")).to eq(Pathname("a/path/test.rb"))
    end

    it "answers original path when pattern doesn't match" do
      expect(Pathname("test.rb").delete_suffix("mismatch")).to eq(Pathname("test.rb"))
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
      c = temp_dir.join("c").tap(&:mkdir)
      b = temp_dir.join("b").tap(&:mkdir)
      a = temp_dir.join("a").tap(&:mkdir)

      expect(temp_dir.directories).to eq([a, b, c])
    end

    it "answers flagged directories" do
      a = temp_dir.join(".test").tap(&:mkdir)

      expect(temp_dir.directories(flag: File::FNM_DOTMATCH)).to eq([temp_dir.join("."), a])
    end

    it "answers empty array without directories" do
      expect(temp_dir.directories).to eq([])
    end
  end

  describe "#empty" do
    it "creates file when file doesn't exist" do
      path = temp_dir.join("test.txt").empty
      expect(path.exist?).to be(true)
    end

    it "empties file with content" do
      path = temp_dir.join("test.txt").write "test"
      path.empty

      expect(path.read).to eq("")
    end

    it "answers self (file)" do
      path = temp_dir.join("test.txt").touch
      expect(path.empty).to eq(path)
    end

    it "creates directory when directory doesn't exist" do
      path = temp_dir.join("test").empty
      expect(path.exist?).to be(true)
    end

    it "empties empty directory" do
      temp_dir.empty
      expect(temp_dir.children).to eq([])
    end

    it "empties directory with files and directories" do
      temp_dir.join("test/nested").mkpath.join("a.txt").touch
      temp_dir.join("test/b.txt").touch
      temp_dir.join("c.txt").touch
      temp_dir.empty

      expect(temp_dir.children).to eq([])
    end

    it "answers self (directory)" do
      expect(temp_dir.empty).to eq(temp_dir)
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
      c = temp_dir.join("c.txt").tap(&:touch)
      b = temp_dir.join("b.txt").tap(&:touch)
      a = temp_dir.join("a.txt").tap(&:touch)

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
      subject(:path) { ancestors.join "three" }

      let(:ancestors) { temp_dir.join "one", "two" }

      it "creates ancestors" do
        path.make_ancestors
        expect(ancestors.exist?).to be(true)
      end

      it "does not create descendant path" do
        path.make_ancestors
        expect(path.exist?).to be(false)
      end
    end

    context "when file" do
      subject(:path) { ancestors.join "three.txt" }

      let(:ancestors) { temp_dir.join "one", "two" }

      it "creates ancestors" do
        path.make_ancestors
        expect(ancestors.exist?).to be(true)
      end

      it "does not create descendant path" do
        path.make_ancestors
        expect(path.exist?).to be(false)
      end
    end

    it "answers itself" do
      path = temp_dir.join "one", "two", "three.txt"
      expect(path.make_ancestors).to eq(path)
    end
  end

  describe "#make_dir" do
    subject(:path) { temp_dir.join "demo" }

    it "makes new directory" do
      path.make_dir
      expect(path.exist?).to be(true)
    end

    it "answers itself when existing" do
      path.make_dir
      expect(path.make_dir).to eq(path)
    end

    it "answers itself when not existing" do
      expect(path.make_dir).to eq(path)
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

  describe "#puts" do
    let(:path) { temp_dir.join("test.txt").touch }

    it "writes to file with newline" do
      path.puts "Test."
      expect(path.read).to eq("Test.\n")
    end

    it "answers itself" do
      expect(path.puts("Test.")).to eq(path)
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
    subject(:path) { temp_dir.join "test" }

    it "removes exsiting directory" do
      path.make_dir.remove_dir
      expect(path.exist?).to be(false)
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

  describe "#rewrite" do
    subject(:path) { temp_dir.join "test.txt" }

    before { path.write "This is a [text]." }

    it "reads and writes file" do
      path.rewrite { |content| content.sub "[text]", "test" }
      expect(path.read).to eq("This is a test.")
    end

    it "does nothing without a block" do
      path.rewrite
      expect(path.read).to eq("This is a [text].")
    end

    it "answers self" do
      rewrite = path.rewrite { "Test." }
      expect(rewrite).to eq(path)
    end
  end

  describe "#touch" do
    context "with existing directory" do
      subject(:path) { temp_dir.join("test").make_dir }

      it_behaves_like "a touchable path"
    end

    context "with existing file" do
      subject(:path) { temp_dir.join("test.txt").write "This is a test." }

      it_behaves_like "a touchable path"
    end

    context "without existing path" do
      subject(:path) { temp_dir.join "test.txt" }

      it "creates empty file" do
        path.touch
        expect(path.read).to eq("")
      end

      it "answers self" do
        expect(path.touch).to eq(path)
      end
    end

    it "fails when given a nested directory structure that doesn't exist" do
      expectation = proc { temp_dir.join("a/b/c/d.txt").touch }
      expect(&expectation).to raise_error(Errno::ENOENT, /no such file or directory/i)
    end
  end

  describe "#write" do
    subject(:path) { temp_dir.join "test.txt" }

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
