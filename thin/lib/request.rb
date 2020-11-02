module Thin
	class Request
	  attr_accessor :env

	  def initialize
	    @parser = nil
	    @nparsed = 0
	    @env = {}
	  end

	  def parse data
	    # @parser.execute(@env, data, @nparsed)
	  end
	end
end