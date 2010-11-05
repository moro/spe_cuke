require 'spe_cuke/target/base'

module SpeCuke::Target
  class Rspec < Base
    class << self
      attr_accessor :default_options
      def suitable?(file)
        file =~ /_spec\.rb/
      end
    end
    self.default_options = ['--color']

    def execute!
      @env.spork_running? ? execute_direct! : super
    end

    private
    # XXX refactor
    def execute_direct!
      begin
        DRb.start_service("druby://localhost:0")
      rescue SocketError, Errno::EADDRNOTAVAIL
        DRb.start_service("druby://:0")
      end
      puts "direct executing `spork_server.run(#{cmd_parameters.flatten.join(" ")})'"
      @env.spork_server.run([fn_and_line], STDERR, STDOUT)
    end

    def raw_commands
      ([@env.command(spec_command_base)] + cmd_parameters).flatten
    end

    def cmd_parameters
      cmds = []
      cmds << self.class.default_options
      cmds << '-fn' if @line # XXX
      cmds << fn_and_line
    end

    def spec_command_base
      v = @env.bundled_version('rspec')

      (v.nil? || v < Gem::Version.new("2.0.0.beta.0")) ? 'spec' : 'rspec'
    end

    def rake_commands
      cmds = [@env.command('rake'), 'spec', "SPEC=#{fn_and_line}"]
      if @line
        cmds << ["SPEC_OPTS=#{self.class.default_options.join(' ')} --format nested"]
      else
        # use spec/spec.opts instead of self.class.default_options
      end
      cmds
    end

    def fn_and_line
      @line ? "#{@fname}:#{@line}" : @fname
    end
  end
end
