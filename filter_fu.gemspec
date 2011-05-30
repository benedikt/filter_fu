Gem::Specification.new do |s|
  s.name          = "filter_fu"
  s.version       = "0.6.0"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Benedikt Deicke"]
  s.email         = ["benedikt@synatic.net"]
  s.homepage      = "http://github.com/benedikt/filter_fu"
  s.summary       = "Filter ActiveRecord models using scopes"
  s.description   = "This Ruby on Rails plugin adds a filtered_by method to your models. It accepts a hash of filters that are applied using scopes. In addition the plugin adds some view helpers to easily build filter forms."

  s.has_rdoc      = true
  s.rdoc_options  = ['--main', 'README.rdoc', '--charset=UTF-8']
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']

  s.files         = Dir.glob('{lib,spec}/**/*') + %w(LICENSE README.rdoc Rakefile Gemfile Gemfile.lock .rspec)

  s.add_runtime_dependency('rails', ['~> 3.0.0'])
  s.add_development_dependency('rspec', ['~> 2.0'])
  s.add_development_dependency('rspec-rails', ['~> 2.0'])
  s.add_development_dependency('webrat', ['>= 0.7.2'])
  s.add_development_dependency('autotest', ['>= 4.3.2'])
  s.add_development_dependency('hanna-nouveau', ['>= 0.2.2'])
end

