class CalledMethod
  attr_reader :name, :args, :return_value

  def initialize(name, args: [], return_value:)
    @name = name
    @args = args
    @return_value = return_value
  end
end
