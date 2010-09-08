require 'spe_cuke/target/rspec'

module SpeCuke
  module Target
    def for(file)
      Base.subclasses.detect{|t| t.suitable?(file) }
    end
    module_function :for
  end
end
