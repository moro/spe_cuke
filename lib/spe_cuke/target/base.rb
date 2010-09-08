
module SpeCuke
  module Target
    class Base
      class << self
        attr_reader :subclasses

        def inherited(sub)
          @subclasses << sub
        end
      end
      @subclasses = []

      def initialize(env, fname, line = nil)
        @fname = fname
        @line = line
        @env = env
      end

      def execute!
        commands = @env.has_rakefile? ? rake_commands : raw_commands
        SpeCuke.wrap_execute!( commands.flatten )
      end
    end
  end
end

