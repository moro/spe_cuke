require 'spec_helper'
require 'spe_cuke/target'
require 'spe_cuke/environment'

module SpeCuke

describe Target, 'detection' do
  it { Target.for('features/foo/some_feature.feature').should == Target::Cucumber }
end

describe Target::Cucumber do
  before do
    @env = Environment.new
    @env.stub!(:bundlized?).and_return false
    @env.stub!(:gem_format_executable?).and_return false

    Target::Cucumber.default_options = ['--color']
  end

  [
    [nil, false, %w[cucumber --color features/foo/some_feature.features]],
    [40,  false, %w[cucumber --color --format=pretty features/foo/some_feature.features:40]],
    [nil, true,  %w[rake cucumber FEATURE=features/foo/some_feature.features]],
    [40,  true,  %w[rake cucumber FEATURE=features/foo/some_feature.features:40 CUCUMBER_FORMAT=pretty]],
  ].each do |line, prefer_rake, expectation|
    context "features/foo/some_feature.features| line:#{line}/rake:#{prefer_rake}" do
      before do
        @env.stub!(:prefer_rake?).and_return prefer_rake
        @target = Target::Cucumber.new(@env, 'features/foo/some_feature.features', line)
        SpeCuke.should_receive(:wrap_execute!).with(expectation)
      end

      it("should invoke `#{expectation.join(' ')}'"){ @target.execute! }
    end
  end
end

end

