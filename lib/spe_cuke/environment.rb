require 'rbconfig'
require 'pathname'
require 'yaml'

module SpeCuke
  class Environment
    def initialize(root = '.')
      @root = Pathname.new(root)
    end

    def command(cmd)
      bundlized? ? bundle_exec << cmd : [executable_name(cmd)]
    end

    def bundlized?
      (@root + 'Gemfile').exist?
    end

    def gem_format_executable?
      @_gemrc = YAML.load_file(Pathname.new(ENV['HOME']) + '.gemrc')
      @_gemrc['gem'].include?('--format-executable')
    end

    def has_rakefile?
      (@root + 'Rakefile').exist?
    end

    private
    def bundle_exec
      [executable_name('bundle'), 'exec']
    end

    def executable_name(base)
      if gem_format_executable?
        base + RbConfig::CONFIG['RUBY_INSTALL_NAME'].sub(/\Aruby/, '')
      else
        base
      end
    end
  end
end
