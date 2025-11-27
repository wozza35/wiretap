# frozen_string_literal: true

require 'wiretap/called_method'
require 'wiretap/block_proxy'

module Wiretap
  class Proxy
    attr_reader :called_methods

    def initialize(target)
      @target = target
      @called_methods = []
    end

    def method_missing(method_name, *args, &block)
      block_proxy = BlockProxy.new(block) if block_given?

      result = target.public_send(method_name, *args, &(block_proxy || block))

      @called_methods << CalledMethod.new(
        method_name,
        args: args,
        yielded_values: block_proxy&.yielded_values,
        return_value: result
      )

      result
    end

    def respond_to_missing?(method_name, include_private = false)
      target.respond_to?(method_name, include_private) || super
    end

    private

    attr_reader :target
  end
end
