module SideKiq
  class CLI
    include Singleton

    def run
      load_workers
      launcher = SideKiq::Launcher.new
      launcher.run
    end

    def load_workers
      Dir["./workers/*.rb"].each { |file| require file }
    end
  end
end