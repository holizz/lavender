module Lavender
  class Converter
    def initialize options
      @options = options
      @options[:defaults] ||= {}
    end

    def render
      yaml = YAML.load_stream @options[:page]
      conf = nil
      page = nil

      case yaml[0]
      when String
        conf = {}
        page = yaml[0]
      when Hash
        conf = yaml[0]
        page = yaml[1]
      else
        raise ArgumentError, 'first document must be Hash or String'
      end

      pro = if conf.has_key? 'processor'
              conf['processor']
            else
              @options[:defaults][:processor]
            end
      pro = pro.to_sym unless pro.nil?
      r = Renderer.new(pro, page)
      output = r.render(conf)

      layout = if conf.has_key? 'layout'
                 conf['layout']
               else
                 @options[:defaults][:layout]
               end
      layout = layout.to_sym unless layout.nil?
      if layout
        hsh = @options[:layouts][layout]
        pro = hsh.keys.first
        content = hsh[pro]
        r = Renderer.new(pro, content)
        output = r.render(conf) { output }
      end

      output
    end
  end
end
