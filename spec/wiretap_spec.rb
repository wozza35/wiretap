# frozen_string_literal: true

require 'spec_helper'
require 'wiretap/proxy'

RSpec.describe Wiretap do
  it "has a version number" do
    expect(Wiretap::VERSION).not_to be nil
  end

  describe ".monitor" do
    it "returns a Proxy wrapping the target object" do
      target = Object.new
      expect(Wiretap::Proxy).to receive(:new).with(target).and_return(proxy = double)
      expect(Wiretap.monitor(target)).to be(proxy)
    end
  end
end
