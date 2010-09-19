module Lavender
  class Renderer
    def initialize type, input
      @type = type
      @input = input
    end

    def render vars = {}, &block
      @vars = vars

      case @type
      when :raw
        @input
      when :erb
        def method_missing name
          @vars[name] || @vars[name.to_s]
        end
        ERB.new(@input).result(binding)
      when :haml
        Haml::Engine.new(@input).to_html(Object.new, @vars, &block)
      end
    end
  end
end
