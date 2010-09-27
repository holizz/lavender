require 'fileutils'

module Lavender
  class Static
    def initialize
      @config = Lavender::Config.new
    end

    def run
      # Layouts

      layouts = {}
      Dir["#{path(:layouts)}/**/*"].each do |file|
        name, ext = file.sub(/^#{path(:layouts)}\//,'').match(/^(.+)\.([^\.]+)$/)[1..-1]
        layouts[name.to_sym] = {ext.to_sym => File.read(file)}
      end

      # Pages
      Dir["#{path(:pages)}/**/*.yml"].each do |file|
        target = file.sub(/^#{path(:pages)}/, path(:compiled))
        target.sub!(/\.yml$/, '')

        FileUtils.mkdir_p File.dirname(target)

        conv = Lavender::Converter.new(:page => File.read(file), :layouts => layouts, :defaults => defaults)
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
