module Wiretap
  class Result
    def initialize(proxied_object)
      @proxied_object = proxied_object
    end

    def to_h
      result = object_attributes
      result.merge!(
        called_methods: proxied_object.wiretap_called_methods.map do |called_method|
          {
            name: called_method.name,
            args: called_method.args&.any? ? called_method.args : nil,
            yielded_values: called_method.yielded_values&.any? ? called_method.yielded_values : nil,
            result: self.class.new(called_method.return_value).to_h
          }.compact
        end
      ) if proxied_object.wiretap_called_methods.any?
      result
    end

    private

    attr_reader :proxied_object

    def object_attributes
      {
        name: proxied_object.wiretap_target_class,
        value: proxied_object.wiretap_target_value
      }
    end
  end
end
