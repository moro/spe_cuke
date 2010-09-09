require 'spe_cuke/target/base'

module SpeCuke::Target
  class Cucumber < Base
    class << self
      def suitable?(file)
        file =~ /\.feature\Z/
      end
    end
    self.default_options = ['--color']

    private
    def raw_commands
      cmds = [@env.command('cucumber')]
      cmds << self.class.default_options
      if @line
        cmds << '--format=pretty' # XXX
      end
      cmds << fn_and_line
    end

    def rake_commands
      cmds = [@env.command('rake'), 'cucumber', "FEATURE=#{fn_and_line}"]
      if @line
        cmds << ["CUCUMBER_FORMAT=pretty"]
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
