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

    private
    def raw_commands
      cmds = [@env.command('spec')]
      cmds << self.class.default_options
      cmds << '-fn' if @line # XXX
      cmds << '--drb' if @env.spork_running?
      cmds << fn_and_line
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
