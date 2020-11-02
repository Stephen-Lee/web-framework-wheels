module EventMachine
  class EvmaTCPClient < StreamObject
    def initialize io
      super
      @pending = true
    end
  end
end