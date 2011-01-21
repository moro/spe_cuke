
module SpeCuke
  module Target
    class Base
      class << self
        attr_reader :subclasses

        def inherited(sub)
          @subclasses << sub
        end

        def default_options; @@default_options; end
        def default_options=(opt); @@default_options = opt; end
      end
      @subclasses = []

      def initialize(env, fname, line = nil)
        @fname = fname
        @line = line
        @env = env
      end

      def execute!
        commands = @env.prefer_rake? ? rake_commands : raw_commands
        SpeCuke.wrap_execute!( commands.flatten )
      end

      private
      # XXX refactor
      def execute_direct!(port)
        begin
          DRb.start_service("druby://localhost:0")
        rescue SocketError, Errno::EADDRNOTAVAIL
          DRb.start_service("druby://:0")
        end
        puts "direct executing `spork_server.run(#{Array(fn_and_line).join(" ")})'"
        @env.spork_server(port).run(Array(fn_and_line), STDERR, STDOUT)
      end
    end
  end
end

