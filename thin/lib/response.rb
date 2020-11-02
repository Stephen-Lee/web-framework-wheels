module Thin
	class Response
	  attr_accessor :status
	  attr_accessor :body

	  def head
	    "HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n"
	  end

	  def each
	    yield head
	    @body.each { |chunk|
	      yield chunk
	    }
	  end
	end
end