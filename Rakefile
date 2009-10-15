require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "filter_fu"
    gem.summary = %Q{Filter ActiveRecord models using named_scopes}
    gem.description = %Q{This Ruby on Rails plugin adds a filtered_by method to your models. It accepts a hash of filters that are applied using named_scopes. In addition the plugin adds some view helpers to easily build filter forms.}
    gem.email = "benedikt@synatic.net"
    gem.homepage = "http://github.com/benedikt/filter_fu"
    gem.authors = ["Benedikt Deicke"]
    gem.add_development_dependency "rspec"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ['--options', 'spec/spec.opts']
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do 
  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
    spec.rcov_opts = ["--exclude", "^/,^spec/"]
  end

  Spec::Rake::SpecTask.new(:doc) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_opts = ["--color", "--format", "specdoc"]
    spec.pattern = 'spec/**/*_spec.rb'
  end
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "filter_fu #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
