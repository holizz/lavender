module Lavender
  class Converter
    def initialize options
      @options = options
      @options[:defaults] ||= {}
    end

    def render
      yaml = @options[:page]
      conf = nil
      page = nil

      if yaml.match /\A---\s?\n(.+?\n)---\s?\n(.*)\Z/m
        conf = YAML.load($1)
        page = $2
      else
        conf = {}
        page = yaml
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
