require 'spec_helper'
require 'spe_cuke/environment'

module SpeCuke

describe Environment do
  before do
    @env = Environment.new
    @env.stub(:bin_suffix).and_return '187'
    @env.stub(:bundlized?).and_return false
    @env.stub(:gem_format_executable?).and_return false
  end
  subject { @env.command('rails') }

  describe '#command()' do
    context 'bundlized & --gem_format_executable' do
      before do
        @env.stub(:bundlized?).and_return true
        @env.stub(:gem_format_executable?).and_return true
      end

      it { should == %w[bundle187 exec rails] }
    end

    context 'bundlized' do
      before do
        @env.stub(:bundlized?).and_return true
      end

      it { should == %w[bundle exec rails] }
    end

    context '--gem_format_executable' do
      before do
        @env.stub(:gem_format_executable?).and_return true
      end

      it { should == %w[rails187] }
    end
  end
end

end
