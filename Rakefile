require 'bundler'
require 'bundler/setup'
require 'spec/rake/spectask'

Bundler::GemHelper.install_tasks
Spec::Rake::SpecTask.new do |s|
  s.spec_opts = %w[--color --format=profile]
end
