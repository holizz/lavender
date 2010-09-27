module Lavender
  class Command
    def self.run args
      case args.first
      when 'compile'
        static = Lavender::Static.new
        static.run
      when 'server'
        raise ArgumentError, "Not yet implemented"
      else
        raise ArgumentError, "Command not recognised"
      end
    end
  end
end
