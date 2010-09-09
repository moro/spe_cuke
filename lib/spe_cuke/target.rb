require 'spe_cuke/target/rspec'
require 'spe_cuke/target/cucumber'

module SpeCuke
  module Target
    def for(file)
      Base.subclasses.detect{|t| t.suitable?(file) }
    end
    module_function :for
  end
end
