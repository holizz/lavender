module Lavender
  class Converter
    def initialize options
      @options = options
      @options[:defaults] ||= {}
    end

    def render
      yaml = YAML.load_stream @options[:page]
      case yaml[0]
      when String
        yaml[0]
      when Hash
        conf = yaml[0]

        pro = conf['processor'] || @options[:defaults][:processor]
        pro = pro.to_sym unless pro.nil?
        r = Renderer.new(pro, yaml[1])
        page = r.render(conf)
        output = page

        layout = conf['layout'] || @options[:defaults][:layout]
        layout = layout.to_sym unless layout.nil?
        if layout
          hsh = @options[:layouts][layout]
          pro = hsh.keys.first
          content = hsh[pro]
          r = Renderer.new(pro, content)
          output = r.render(conf) { page }
        end

        output
      else
        raise ArgumentError, 'first document must be Hash or String'
      end
    end
  end
end
