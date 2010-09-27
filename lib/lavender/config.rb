module Lavender
  class Config

    class OpenStruct
      def method_missing(method)
        method = method.to_s
        if @hsh[method].is_a? Hash
          OpenStruct.new(@hsh[method])
        else
          @hsh[method]
        end
      end
      def initialize(hsh)
        @hsh = hsh
      end
      def to_hash
        @hsh
      end
    end

    def method_missing(method, *args)
      @obj.send(method, *args)
    end

    LOCATIONS = %w[config.yml]

    def initialize config = nil
      @config = config
      @config ||= {
        'defaults' => {'layout' => 'default', 'processor' => 'haml'},
        'paths' => {'pages' => 'pages', 'compiled' => 'compiled'},
        'pwd' => Dir.pwd
      }

      user_config = {}
      LOCATIONS.each do |y|
        if File.exist? y
          user_config = YAML::load_file y
          break
        end
      end

      @config = recursive_merge user_config, @config

      @obj = OpenStruct.new @config
    end

    def recursive_merge primary, secondary
      # merges secondary into primary

      return primary unless primary.is_a? Hash

      output = {}

      primary.each_key do |k|
        if secondary.has_key? k
          output[k] = recursive_merge primary[k], secondary[k]
        else
          output[k] = user_config[k]
        end
      end

      (secondary.keys-primary.keys).each do |k|
        output[k] = secondary[k]
      end

      output
    end
  end
end
