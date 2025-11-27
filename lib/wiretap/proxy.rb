# frozen_string_literal: true

require 'wiretap/called_method'

module Wiretap
  class Proxy
    attr_reader :called_methods

    def initialize(target)
      @target = target
      @called_methods = []
    end

    def method_missing(method_name, *args)
      result = target.public_send(method_name, *args)
      @called_methods << CalledMethod.new(method_name,
                                          args: args,
                                          return_value: result)
      result
    end

    def respond_to_missing?(method_name, include_private = false)
      target.respond_to?(method_name, include_private) || super
    end

    private

    attr_reader :target
  end
end
