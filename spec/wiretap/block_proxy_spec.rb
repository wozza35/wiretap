# frozen_string_literal: true

require "spec_helper"
require "wiretap/block_proxy"

RSpec.describe Wiretap::BlockProxy do
  let(:block) { Proc.new {} }
  let(:unit) { described_class.new(block) }

  describe '#to_proc' do
    subject { unit.to_proc }

    it 'returns a Proc' do
      expect(subject).to be_a(Proc)
    end

    it 'delegates to the original block' do
      expect(block).to receive(:call).with(123)
      subject.call(123)
    end
  end

  describe '#yielded_values' do
    subject { unit.yielded_values }

    it 'records all values yielded to the supplied block' do
      [:foo, :bar, :baz].each(&unit)
      expect(subject).to contain_exactly([:foo], [:bar], [:baz])
    end
  end
end
