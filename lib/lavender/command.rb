module Lavender
  class Command
    def self.run args
      case args.first
      when 'compile'
        static = Lavender::Static.new
        static.run
      when 'server'
        raise ArgumentError, "Not yet implemented"
      end
    end
  end
end
