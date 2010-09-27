require 'fileutils'

module Lavender
  class Static
    def initialize verbose = false
      @config = Lavender::Config.new
      @verbose = verbose
    end

    def run
      # Public
      Dir["#{path(:public)}/**/*"].each do |file|
        out = file.sub(/^#{path(:public)}/, path(:compiled))
        write_file out, File.read(file)
      end

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

        conv = Lavender::Converter.new(:page => File.read(file), :layouts => layouts, :defaults => defaults)

        write_file target, conv.render
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

    def write_file path, data
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'w+') do |f|
        f.write data
      end
      if @verbose
        basepath = path.sub(/^#{@config.pwd}\//,'')
        puts "  create: #{basepath}"
      end
    end
  end
end
