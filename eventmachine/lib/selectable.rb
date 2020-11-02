require 'forwardable'
require 'fcntl'

class IO
  extend Forwardable
  def_delegator :@my_selectable, :uuid
  def_delegator :@my_selectable, :select_for_reading?
  def_delegator :@my_selectable, :select_for_writing?
  def_delegator :@my_selectable, :eventable_read
  def_delegator :@my_selectable, :eventable_write
  def_delegator :@my_selectable, :send_data
  def_delegator :@my_selectable, :close_scheduled?
  def_delegator :@my_selectable, :schedule_close
end

module EventMachine
	class Selectable
	  attr_accessor :io
	  attr_reader :uuid

	  def initialize io
	    @io = io
	    @uuid = UuidGenerator.generate
	    m = @io.fcntl(Fcntl::F_GETFL, 0)
	    @io.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK | m)

	    @close_scheduled = false

	    se = self
	    @io.instance_eval { @my_selectable = se }
	    Reactor.instance.add_selectable @io
	  end

	  def select_for_reading?
	    false
	  end

	  def select_for_writing?
	    false
	  end

	  def close_scheduled?
	    @close_scheduled
	  end

	  def schedule_close
	    @close_scheduled = true
	  end
	end
end
