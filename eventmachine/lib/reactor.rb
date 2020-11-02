require 'set'
require 'singleton'

module EventMachine
  class Reactor
    include Singleton

    def initialize
      initialize_for_run
    end

    def initialize_for_run
      @current_loop_time = Time.now

      @timers = SortedSet.new
      @selectables = {}
    end

    def run
      loop {
        @current_loop_time = Time.now

        run_timers
        run_selectors
      }
    end

    def run_timers
      @timers.each {|t|
        break unless t.first <= @current_loop_time

        @timers.delete t
        EventMachine.event_callback "", TimerFired, t.last
      }
    end

    def run_selectors
      readers = @selectables.values.select { |io| io.select_for_reading? }
      writers = @selectables.values.select { |io| io.select_for_writing? }
      s = select(readers, writers, nil, 0.1)
      s and s[0] and s[0].each { |r| r.eventable_read }
      s and s[1] and s[1].each { |w| w.eventable_write }

      @selectables.delete_if {|k,io|
        if io.close_scheduled?
          io.close
          # TODO connection unbound
          true
        end
      }
    end

    def get_selectable uuid
      @selectables[uuid]
    end

    def add_selectable io
      @selectables[io.uuid] = io
    end

    def install_oneshot_timer interval
      uuid = UuidGenerator::generate
      @timers.add([Time.now + interval, uuid])
      uuid
    end
  end
end