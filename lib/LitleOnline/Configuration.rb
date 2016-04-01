=begin
Copyright (c) 2011 Litle & Co.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end

require 'yaml'
#
# Loads the configuration from a file
#
module LitleOnline
  class Configuration
    DEFAULT = LitleOnline::EnvironmentVariables.default

    class << self
      # External logger, if specified
      attr_accessor :logger
    end

    def config
      config_dir = ENV.fetch('LITLE_CONFIG_DIR', ENV['HOME'])
      config_file = File.join(config_dir, '.litle_SDK_config.yml')

      # if Env variable exist, then just override the data from config file
      if File.exist?(config_file)
        YAML.load_file(config_file).merge(env_vars)
      else
        DEFAULT.merge(env_vars)
      end
    rescue
      DEFAULT
    end

    def env_vars
      litle_vars = ENV.select { |k, _v| k.start_with?('litle_') }

      env_vars = litle_vars.map do |k, v|
        [k.gsub('litle_', ''), v]
      end

      known_vars = env_vars.select { |k, _v| DEFAULT.keys.include?(k) }

      Hash[known_vars]
    end
  end
end
