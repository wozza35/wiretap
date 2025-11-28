# frozen_string_literal: true

require_relative "wiretap/version"
require_relative "wiretap/proxy"

module Wiretap
  class Error < StandardError; end

  def self.monitor(target)
    Proxy.new(target)
  end
end
