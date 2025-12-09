# frozen_string_literal: true

require 'wiretap/called_method'
require 'wiretap/block_proxy'
require 'wiretap/result'

module Wiretap
  class Proxy < SimpleDelegator

    def initialize(target)
      @target = target
      @called_methods = []
      super(target)
    end

    def method_missing(method_name, *args, &block)
      block_proxy = BlockProxy.new(block) if block_given?

      value = Proxy.new(target.public_send(method_name, *args, &(block_proxy || block)))

      @called_methods << CalledMethod.new(
        method_name,
        args: args,
        yielded_values: block_proxy&.yielded_values,
        return_value: value
      )

      value
    end

    def respond_to_missing?(method_name, include_private = false)
      target.respond_to?(method_name, include_private) || super
    end

    def wiretap_called_methods
      called_methods
    end

    def wiretap_target_class
      target.class.name
    end

    def wiretap_target_value
      target.to_s
    end

    def wiretap_result
      Result.new(self)
    end

    private

    attr_reader :target, :called_methods
  end
end
