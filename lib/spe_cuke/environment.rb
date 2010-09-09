require 'rbconfig'
require 'pathname'
require 'yaml'

module SpeCuke
  class Environment
    def initialize(root = '.', options = {})
      @root = Pathname.new(root)
      @options = options
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

    def prefer_rake?
      has_rakefile? && @options[:prefer_rake]
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
        base + bin_suffix
      else
        base
      end
    end

    def bin_suffix
      RbConfig::CONFIG['RUBY_INSTALL_NAME'].sub(/\Aruby/, '')
    end
  end
end
