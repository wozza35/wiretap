class CalledMethod
  attr_reader :name, :args, :return_value, :yielded_values

  def initialize(name, args: [], yielded_values: nil, return_value:)
    @name = name
    @args = args
    @return_value = return_value
    @yielded_values = yielded_values
  end
end
