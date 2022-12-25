# frozen_string_literal: true

require "spec_helper"

RSpec.describe Refinements::Structs do
  using described_class

  describe ".with_keywords" do
    context "with positional construction" do
      subject(:struct) { Struct.new :a, :b, :c }

      it "answers struct with all positions filled" do
        expect(struct.with_keywords(a: 1, b: 2, c: 3)).to eq(struct[1, 2, 3])
      end

      it "answers struct with first position filled" do
        expect(struct.with_keywords(a: 1)).to eq(struct[1, nil, nil])
      end

      it "answers struct with last position filled" do
        expect(struct.with_keywords(c: 1)).to eq(struct[nil, nil, 1])
      end
    end

    context "with keyword construction" do
      subject(:struct) { Struct.new :a, :b, :c, keyword_init: true }

      it "answers struct with all positions filled" do
        expect(struct.with_keywords(a: 1, b: 2, c: 3)).to eq(struct[a: 1, b: 2, c: 3])
      end

      it "answers struct with some positions filled" do
        expect(struct.with_keywords(a: 1)).to eq(struct[a: 1, b: nil, c: nil])
      end
    end
  end

  describe ".with_positions" do
    context "with positional construction" do
      subject(:struct) { Struct.new :a, :b, :c }

      it "answers struct with all positions filled" do
        expect(struct.with_positions(1, 2, 3)).to eq(struct[1, 2, 3])
      end

      it "answers struct with some positions filled" do
        expect(struct.with_positions(1)).to eq(struct[1, nil, nil])
      end
    end

    context "with keyword construction" do
      subject(:struct) { Struct.new :a, :b, :c, keyword_init: true }

      it "answers struct with all positions filled" do
        expect(struct.with_positions(1, 2, 3)).to eq(struct[a: 1, b: 2, c: 3])
      end

      it "answers struct with some positions filled" do
        expect(struct.with_positions(1)).to eq(struct[a: 1, b: nil, c: nil])
      end
    end
  end

  shared_examples "a merge" do |method|
    context "with positional construction" do
      subject(:struct) { Struct.new(:a, :b, :c).new 1, 2, 3 }

      it "answers struct with attributes rebuilt" do
        expect(struct.public_send(method, a: 7, b: 8, c: 9)).to eq(struct.class[7, 8, 9])
      end

      it "answers struct with some attributes rebuilt" do
        expect(struct.public_send(method, a: 7, c: 9)).to eq(struct.class[7, 2, 9])
      end

      it "answers identical struct with no arguments" do
        expect(struct.public_send(method)).to eq(struct.class[1, 2, 3])
      end
    end

    context "with keyword construction" do
      subject(:struct) { Struct.new(:a, :b, :c, keyword_init: true).new a: 1, b: 2, c: 3 }

      it "answers struct with attributes rebuilt" do
        expect(struct.public_send(method, a: 7, b: 8, c: 9)).to eq(struct.class[a: 7, b: 8, c: 9])
      end

      it "answers struct with some attributes rebuilt" do
        expect(struct.public_send(method, a: 7, c: 9)).to eq(struct.class[a: 7, b: 2, c: 9])
      end

      it "answers identical struct with no arguments" do
        expect(struct.public_send(method)).to eq(struct.class[a: 1, b: 2, c: 3])
      end
    end

    context "with hash" do
      subject(:struct) { Struct.new(:a, :b, :c).new 1, 2, 3 }

      let(:hash) { {a: 8, c: 9} }

      it "answers struct with attributes rebuilt" do
        expect(struct.public_send(method, hash)).to eq(struct.class[8, 2, 9])
      end
    end

    context "with struct missing attributes" do
      let(:struct_a) { Struct.new(:a, :b, :c).new 1, 2, 3 }
      let(:struct_b) { Struct.new(:a, :b, :c, keyword_init: true).new a: 8, c: 9 }

      it "answers struct with some attributes rebuilt and others nil'ed out" do
        expect(struct_a.public_send(method, struct_b)).to eq(struct_a.class[8, nil, 9])
      end
    end

    context "with any object that responds as a hash" do
      subject(:struct) { Struct.new(:a, :b, :c).new 1, 2, 3 }

      let(:object) { Object.new.tap { |instance| def instance.to_h = {c: 9} } }

      it "answers struct attributes rebuilt" do
        expect(struct.public_send(method, object)).to eq(struct.class[1, 2, 9])
      end
    end
  end

  describe "#merge" do
    it_behaves_like "a merge", :merge

    it "doesn't mutate itself with positional construction" do
      struct = Struct.new(:a, :b, :c).new 1, 2, 3
      struct.merge a: 7, b: 8, c: 9

      expect(struct).to eq(struct.class[1, 2, 3])
    end

    it "doesn't mutate itself with keyword construction" do
      struct = Struct.new(:a, :b, :c, keyword_init: true).new a: 1, b: 2, c: 3
      struct.merge a: 7, b: 8, c: 9

      expect(struct).to eq(struct.class[a: 1, b: 2, c: 3])
    end
  end

  describe "#merge!" do
    it_behaves_like "a merge", :merge!

    it "mutates itself with positional construction" do
      struct = Struct.new(:a, :b, :c).new 1, 2, 3
      struct.merge! a: 7, b: 8, c: 9

      expect(struct).to eq(struct.class[7, 8, 9])
    end

    it "mutates itself with keyword construction" do
      struct = Struct.new(:a, :b, :c, keyword_init: true).new a: 1, b: 2, c: 3
      struct.merge! a: 7, b: 8, c: 9

      expect(struct).to eq(struct.class[a: 7, b: 8, c: 9])
    end
  end

  shared_examples "a revalue" do |method|
    it "answers transformed values with block" do
      expectation = struct.public_send(method) { |value| value * 2 }
      expect(expectation).to eq(struct.class.new.merge(a: 2, b: 4, c: 6))
    end

    it "answers transformed values with hash and block" do
      expectation = struct.public_send(method, b: 1) { |previous, current| previous + current }
      expect(expectation).to eq(struct.class.new.merge(a: 1, b: 3, c: 3))
    end

    it "answers itself when block isn't given" do
      expect(struct.public_send(method)).to eq(struct)
    end
  end

  describe "#revalue" do
    context "with positional construction" do
      subject(:struct) { Struct.new(:a, :b, :c).new 1, 2, 3 }

      it_behaves_like "a revalue", :revalue

      it "doesn't mutate itself" do
        struct.revalue { |value| value * 2 }
        expect(struct).to eq(struct.class[1, 2, 3])
      end
    end

    context "with keyword construction" do
      subject(:struct) { Struct.new(:a, :b, :c, keyword_init: true).new a: 1, b: 2, c: 3 }

      it_behaves_like "a revalue", :revalue

      it "doesn't mutate itself" do
        struct.revalue { |value| value * 2 }
        expect(struct).to eq(struct.class[a: 1, b: 2, c: 3])
      end
    end
  end

  describe "#revalue!" do
    context "with positional construction" do
      subject(:struct) { Struct.new(:a, :b, :c).new 1, 2, 3 }

      it_behaves_like "a revalue", :revalue!

      it "mutates itself" do
        struct.revalue! { |value| value * 2 }
        expect(struct).to eq(struct.class[2, 4, 6])
      end
    end

    context "with keyword construction" do
      subject(:struct) { Struct.new(:a, :b, :c, keyword_init: true).new a: 1, b: 2, c: 3 }

      it_behaves_like "a revalue", :revalue!

      it "mutates itself" do
        struct.revalue! { |value| value * 2 }
        expect(struct).to eq(struct.class[a: 2, b: 4, c: 6])
      end
    end
  end

  shared_examples "a transmute" do |method|
    let(:a_hash) { {r: 10, s: 20, t: 30} }

    it "transforms and merges entire struct" do
      result = struct.public_send method, other, a: :x, b: :y, c: :z
      expect(result).to eq(struct.class.new.merge!(a: 7, b: 8, c: 9))
    end

    it "transforms and merges partial struct" do
      result = struct.public_send method, other, a: :x, c: :z
      expect(result).to eq(struct.class.new.merge!(a: 7, b: 2, c: 9))
    end

    it "transforms and merges entire hash" do
      result = struct.public_send method, a_hash, a: :r, b: :s, c: :t
      expect(result).to eq(struct.class.new.merge!(a: 10, b: 20, c: 30))
    end

    it "transforms and merges partial hash" do
      result = struct.public_send method, a_hash, b: :s
      expect(result).to eq(struct.class.new.merge!(a: 1, b: 20, c: 3))
    end

    it "transforms and merges partial struct" do
      result = struct.public_send method, other, a: :x, c: :z
      expect(result).to eq(struct.class.new.merge!(a: 7, b: 2, c: 9))
    end

    it "answers original struct when no attributes are given" do
      expect(struct.public_send(method, other)).to eq(struct.class.new.merge!(a: 1, b: 2, c: 3))
    end
  end

  describe "#transmute" do
    context "with positional construction" do
      subject(:struct) { Struct.new(:a, :b, :c).new 1, 2, 3 }

      let(:other) { Struct.new(:x, :y, :z).new 7, 8, 9 }

      it_behaves_like "a transmute", :transmute

      it "doesn't mutate itself" do
        struct.transmute other, x: :a
        expect(struct).to eq(struct.class[1, 2, 3])
      end
    end

    context "with keyword construction" do
      subject(:struct) { Struct.new(:a, :b, :c, keyword_init: true).new a: 1, b: 2, c: 3 }

      let(:other) { Struct.new(:x, :y, :z, keyword_init: true).new x: 7, y: 8, z: 9 }

      it_behaves_like "a transmute", :transmute

      it "doesn't mutate itself" do
        struct.transmute other, a: :x
        expect(struct).to eq(struct.class[a: 1, b: 2, c: 3])
      end
    end
  end

  describe "#transmute!" do
    context "with positional construction" do
      subject(:struct) { Struct.new(:a, :b, :c).new 1, 2, 3 }

      let(:other) { Struct.new(:x, :y, :z).new 7, 8, 9 }

      it_behaves_like "a transmute", :transmute!

      it "mutates itself" do
        struct.transmute! other, a: :x
        expect(struct).to eq(struct.class[7, 2, 3])
      end
    end

    context "with keyword construction" do
      subject(:struct) { Struct.new(:a, :b, :c, keyword_init: true).new a: 1, b: 2, c: 3 }

      let(:other) { Struct.new(:x, :y, :z, keyword_init: true).new x: 7, y: 8, z: 9 }

      it_behaves_like "a transmute", :transmute!

      it "mutates itself" do
        struct.transmute! other, a: :x
        expect(struct).to eq(struct.class[a: 7, b: 2, c: 3])
      end
    end
  end
end
