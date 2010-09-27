require 'fileutils'

module Lavender
  class Static
    def initialize
      @config = Lavender::Config.new
    end

    def run
      Dir["#{path(:pages)}/**/*"].each do |file|
        target = file.sub(/^#{path(:pages)}/, path(:compiled))
        target.sub!(/\.yml$/, '')

        FileUtils.mkdir_p File.dirname(target)

        conv = Lavender::Converter.new(:page => File.read(file), :defaults => defaults)
        File.open(target, 'w+') do |f|
          f.write conv.render
        end
      end
    end

    def path path
      File.join(@config.pwd, @config.paths.send(path))
    end

    def defaults
      @config.defaults.to_hash.reduce({}) do |a,b|
        c = b.last
        c = c.to_sym if c.is_a? String
        a[b.first.to_sym] = c
        a
      end
    end
  end
end