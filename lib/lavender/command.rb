module Lavender
  class Command
    def self.run args
      case args.first
      when 'help'
        self.help
      when nil
        self.help

      when 'compile'
        static = Lavender::Static.new
        static.run
      when 'server'
        raise ArgumentError, "Not yet implemented"

      else
        raise ArgumentError, "Command not recognised"
      end
    end

    def self.help
      puts <<END
Usage: lavender command

Commands:
  help      This message
  compile   Compiles the project in the current working directory
END
    end
  end
end
