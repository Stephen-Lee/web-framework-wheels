module SideKiq
  class Manager
    def initialize
      @workers = Set.new
      10.times do
        @workers << Processor.new
      end
    end

    def start
      @workers.each(&:start)
    end
  end
end