module Lavender
  class Converter
    def initialize options
      @options = options
    end

    def render
      yaml = YAML.load_stream @options[:page]
      case yaml[0]
      when String
        yaml[0]
      when Hash
        conf = yaml[0]

        r = Renderer.new(conf['processor'].to_sym, yaml[1])
        page = r.render(conf)
        output = page

        layout = conf['layout']
        if layout
          hsh = @options[:layouts][layout.to_sym]
          processor = hsh.keys.first
          content = hsh[processor]
          r = Renderer.new(processor, content)
          output = r.render(conf) { page }
        end

        output
      else
        raise ArgumentError, 'first document must be Hash or String'
      end
    end
  end
end
