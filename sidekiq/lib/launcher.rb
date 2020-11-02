module SideKiq
  class Launcher
    def initialize
      @manager = Manager.new
      @poller = Scheduled::Poller.new
    end

    def run
      @manager.start
      @poller.start
    end
  end
end
