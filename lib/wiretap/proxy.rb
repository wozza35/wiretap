# frozen_string_literal: true

module Wiretap
  class Proxy
    def initialize(target)
      @target = target
    end

    def method_missing(method_name)
      target.public_send(method_name)
    end

    def respond_to_missing?(method_name, include_private = false)
      target.respond_to?(method_name, include_private) || super
    end

    private

    attr_reader :target
  end
end
