require 'rspec/core'
require 'rspec/core/rake_task'
require 'rdoc/task'

spec = Gem::Specification.load("filter_fu.gemspec")

RSpec::Core::RakeTask.new
task :default => :spec

Rake::RDocTask.new do |rdoc|
  rdoc.generator = 'hanna'
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "#{spec.name} #{spec.version}"
  rdoc.options += spec.rdoc_options
  rdoc.rdoc_files.include(spec.extra_rdoc_files)
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Generates a sandbox Rails app for testing"
namespace :spec do
  task "sandbox" do
    system "rm -rf tmp/sandbox && mkdir -p tmp/ && bundle exec rails new tmp/sandbox --skip-gemfile"
  end
end

desc "Build the .gem file"
task :build do
  system "gem build #{spec.name}.gemspec"
end

desc "Push the .gem file to rubygems.org"
task :release => :build do
  system "gem push #{spec.name}-#{spec.version}.gem"
end
