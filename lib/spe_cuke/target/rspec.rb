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
      if @line
        cmds << ['-l', @line.to_s] if @line
        cmds << '-fn' # XXX
      end
      cmds << @fname
    end

    def rake_commands
      cmds = [@env.command('rake'), 'spec']
      if @line
        cmds << ["SPEC=#{@fname}:#{@line}", "SPEC_OPTS=#{self.class.default_options.join(' ')} --format nested"]
      else
        cmds << "SPEC=#{@fname}"
      end
    end
  end
end
