require 'bundler'
require 'bundler/setup'
require 'rspec'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new do |s|
  s.rspec_opts = %w[--color --format=progress]
end
