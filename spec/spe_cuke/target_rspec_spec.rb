require 'spec_helper'
require 'spe_cuke/target'
require 'spe_cuke/environment'

module SpeCuke

describe Target do
  it { Target.for('spec/foo/bar_spec.rb').should == Target::Rspec }
end

describe Target::Rspec do
  before do
    @env = Environment.new
    @env.stub!(:bundlized?).and_return false
    @env.stub!(:gem_format_executable?).and_return false
    @env.stub!(:spork_running?).and_return false

    Target::Rspec.default_options = ['--color']
  end

  context 'spec/foo/bar_spec.rb' do
    before do
      @env.stub!(:prefer_rake?).and_return false
      @target = Target::Rspec.new(@env, 'spec/foo/bar_spec.rb')
      SpeCuke.should_receive(:wrap_execute!).with(%w[spec --color spec/foo/bar_spec.rb])
    end

    it(%q[spec --color spec/foo/bar_spec.rb]){ @target.execute! }
  end


  context 'spec/foo/bar_spec.rb on line 40' do
    before do
      @env.stub!(:prefer_rake?).and_return false
      @target = Target::Rspec.new(@env, 'spec/foo/bar_spec.rb', 40)
      SpeCuke.should_receive(:wrap_execute!).with(%w[spec --color -fn spec/foo/bar_spec.rb:40])
    end

    it(%q[spec --color -l 40 spec/foo/bar_spec.rb]){ @target.execute! }
  end

  context 'spec/foo/bar_spec.rb on line:40/spork:true' do
    before do
      pending("unknow purpose test")
      @env.stub!(:spork_running?).and_return true
      @env.stub!(:prefer_rake?).and_return false
      @target = Target::Rspec.new(@env, 'spec/foo/bar_spec.rb', 40)
      SpeCuke.should_receive(:wrap_execute!).with(%w[spec --color -fn --drb spec/foo/bar_spec.rb:40])
    end

    it(%q[spec --color -l 40 spec/foo/bar_spec.rb]){ @target.execute! }
  end

  context 'spec/foo/bar_spec.rb w/Rakefile' do
    before do
      @env.stub!(:prefer_rake?).and_return true
      @target = Target::Rspec.new(@env, 'spec/foo/bar_spec.rb')
      SpeCuke.should_receive(:wrap_execute!).with(%w[rake spec SPEC=spec/foo/bar_spec.rb])
    end

    it(%q[rake spec SPEC=spec/foo/bar_spec.rb]){ @target.execute! }
  end

  context 'spec/foo/bar_spec.rb w/Rakefile on line 40' do
    before do
      @env.stub!(:prefer_rake?).and_return true
      @target = Target::Rspec.new(@env, 'spec/foo/bar_spec.rb', 40)
      SpeCuke.should_receive(:wrap_execute!).with(["rake", "spec", "SPEC=spec/foo/bar_spec.rb:40", "SPEC_OPTS=--color --format nested"])
    end

    it(%q[rake spec SPEC=spec/foo/bar_spec.rb:40]){ @target.execute! }
  end
end

end

