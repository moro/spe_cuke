require 'rbconfig'
require 'pathname'
require 'yaml'
require 'drb'
require 'timeout'
begin
  require 'bundler'
rescue LoadError => bundler_not_installed_ignore
end

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
      defined?(Bundler) && (@root + 'Gemfile').exist?
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

    def bundled_version(gem_name)
      return nil unless bundlized?

      lp = Bundler::LockfileParser.new(gemfile_dot_lock)
      lp.specs.detect{|bs| bs.name == gem_name}.version rescue nil
    end

    def spork_running?(port)
      begin
        timeout(1) { (s = spork_server(port)) && s.respond_to?(:run) }
      rescue DRb::DRbConnError, Errno::ECONNREFUSED, Timeout::Error, SocketError, Errno::EADDRNOTAVAIL
        return false
      end
    end

    def spork_server(port = 8989)
      DRbObject.new_with_uri("druby://127.0.0.1:#{port}")
    end

    private
    def gemfile_dot_lock
      (@root + 'Gemfile.lock').read
    end

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
