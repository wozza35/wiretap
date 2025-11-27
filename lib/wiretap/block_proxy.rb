module Wiretap
  class BlockProxy
    attr_reader :yielded_values

    def initialize(original_block)
      @original_block = original_block
      @yielded_values = []
    end

    def to_proc
      Proc.new do |*block_args|
        @yielded_values << block_args
        @original_block.call(*block_args)
      end
    end
  end
end
