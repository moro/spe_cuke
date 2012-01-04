require 'spec_helper'

require 'spe_cuke/environment'
require 'spe_cuke/target/product_code'

module SpeCuke::Target
describe ProductCode do
  describe '.execute!' do
    before do
      @env = ::SpeCuke::Environment.new
      @env.stub!(:bundlized?).and_return false
      @env.stub!(:gem_format_executable?).and_return false
      @env.stub!(:spork_running?).and_return false

      @target = ProductCode.new(@env, 'lib/spe_cuke/target/product_code.rb')

      spec = 'spec/spe_cuke/target/product_code_spec.rb'
      File.should_receive(:exist?).with(spec).and_return true
      SpeCuke.should_receive(:wrap_execute!).with(%w[rspec --color] << spec)
    end
    it("should call wrap_execute with valid args"){ @target.execute! }
  end

  describe '.paired_test' do
    subject do
      SpeCuke::Target::ProductCode.paired_test('lib/spe_cuke/target/product_code.rb')
    end

    it do
      spec = 'spec/spe_cuke/target/product_code_spec.rb'
      File.should_receive(:exist?).with(spec).and_return true
      should == spec
    end

    it do
      spec = 'spec/spe_cuke/target_product_code_spec.rb'
      File.should_receive(:exist?).with('spec/spe_cuke/target/product_code_spec.rb').and_return false
      File.should_receive(:exist?).with(spec).and_return true
      should == spec
    end
  end
end
end

