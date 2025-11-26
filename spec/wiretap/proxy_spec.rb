# frozen_string_literal: true

require "spec_helper"
require "wiretap/proxy"

RSpec.describe Wiretap::Proxy do
  let(:target_class) do
    Class.new do
      def foo
        "bar"
      end

      private

      def baz
        "buzz"
      end
    end
  end
  let(:target) { target_class.new }
  let(:unit) { Wiretap::Proxy.new(target) }

  describe "method call" do
    it "invokes method on the target object and returns the result" do
      expect(target).to receive(:foo).and_call_original
      expect(unit.foo).to eq("bar")
    end

    context "when calling a private method" do
      it "raises a NoMethodError" do
        expect { unit.baz }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true for methods that the target responds to' do
      expect(unit.respond_to?(:foo)).to be true
    end

    it 'returns false for methods the target does not respond to' do
      expect(unit.respond_to?(:non_existent_method)).to be false
    end
  end
end
