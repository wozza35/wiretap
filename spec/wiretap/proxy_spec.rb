# frozen_string_literal: true

require "spec_helper"
require "wiretap/proxy"

RSpec.describe Wiretap::Proxy do
  let(:target) { target_class.new }
  let(:unit) { Wiretap::Proxy.new(target) }

  describe "method call" do
    let(:target_class) do
      Class.new do
        def foo
          "foo_result"
        end

        def bar
          "bar_result"
        end

        private

        def baz; end
      end
    end

    it "invokes method on the target object and returns the result" do
      expect(target).to receive(:foo).and_call_original
      expect(unit.foo).to eq("foo_result")
    end

    it "records method calls and their return values" do
      unit.foo
      unit.foo
      unit.bar
      unit.foo
      expect(unit.called_methods.map(&:name)).to eq(%i[foo foo bar foo])
      expect(unit.called_methods.map(&:return_value)).to eq(%w[foo_result foo_result bar_result foo_result])
    end

    context "when calling a private method" do
      it "raises a NoMethodError" do
        expect { unit.baz }.to raise_error(NoMethodError)
      end
    end
  end

  describe "method calls with arguments" do
    let(:target_class) do
      Class.new do
        def add(a, b)
          a + b
        end
      end
    end

    it "invokes method with arguments on the target object and returns the result" do
      expect(target).to receive(:add).with(2, 3).and_call_original
      expect(unit.add(2, 3)).to eq(5)
    end

    it "records method calls and their arguments" do
      unit.add(1, 2)
      unit.add(3, 4)
      expect(unit.called_methods.map(&:name)).to eq([:add, :add])
      expect(unit.called_methods.map(&:args)).to eq([[1, 2], [3, 4]])
      expect(unit.called_methods.map(&:return_value)).to eq([3, 7])
    end
  end

  describe "method calls with blocks" do
    let(:target_class) do
      Class.new do
        def foo(n)
          yield n
          yield n + 1
        end
      end
    end

    it "invokes method with block on the target object and returns the last yielded value" do
      expect(target).to receive(:foo).with(5).and_call_original
      result = unit.foo(5) { |x| x * 2 }
      expect(result).to eq 12
    end

    it 'records the values yielded to the block' do
      unit.foo(5) {}
      expect(unit.called_methods.map(&:yielded_values)).to contain_exactly([[5], [6]])
    end
  end

  describe "nested method calls" do
    let(:target) { 'foo' }

    subject do
      unit.reverse.upcase
    end

    it 'handles nested method calls correctly' do
      expect(subject).to eq 'OOF'
      expect(unit.called_methods.map(&:name)).to eq([:reverse])
      second_proxy = unit.called_methods.first.return_value
      expect(second_proxy.called_methods.map(&:name)).to eq([:upcase])
    end
  end

  describe '#respond_to_missing?' do
    let(:target_class) do
      Class.new do
        def foo; end
      end
    end

    it 'returns true for methods that the target responds to' do
      expect(unit.respond_to?(:foo)).to be true
    end

    it 'returns false for methods the target does not respond to' do
      expect(unit.respond_to?(:non_existent_method)).to be false
    end
  end
end
