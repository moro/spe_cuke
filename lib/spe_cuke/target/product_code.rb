require 'forwardable'
require 'spe_cuke/target/base'
require 'spe_cuke/target/rspec'

module SpeCuke::Target
  class ProductCode < Base
    extend Forwardable
    class << self
      attr_accessor :default_options
      def suitable?(file)
        !!paired_test(file)
      end

      def paired_test(file)
        top, *rests = file.split('/')
        return nil unless %w[lib app].include?(top)
        spec = File.basename(rests.pop, '.rb') + '_spec.rb'
        exactlly_paired(rests, spec) || fuzzy_paired(rests, spec)
      end

      private
      def exactlly_paired(dirs, spec)
        spec = ['spec', dirs, spec].flatten.join('/')
        File.exist?(spec) && spec
      end

      def fuzzy_paired(dirs, spec)
        dirs = dirs.dup
        while merged = dirs.pop
          spec = [merged, spec].join('_')
          fullpath = ['spec', dirs, spec].flatten.join('/')
          return fullpath if File.exist?(fullpath)
        end
      end
    end

    def_delegator :rspec_target, :execute!

    private
    def rspec_target
      @rspec_target ||= Rspec.new(@env, self.class.paired_test(@fname))
    end
  end
end

