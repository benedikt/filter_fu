# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'rails/all'
require 'filter_fu'

require File.dirname(__FILE__) + "/../tmp/sandbox/config/environment"

require 'rspec/rails'

ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), 'db', 'debug.log'))

configuration = YAML.load_file(File.join(File.dirname(__FILE__), 'db', 'database.yml'))
ActiveRecord::Base.establish_connection(configuration[ENV["DB"] || "sqlite3"])

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load(File.join(File.dirname(__FILE__), "db", "schema.rb"))
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If you'd prefer not to run each of your examples within a transaction,
  # uncomment the following line.
  # config.use_transactional_examples false
end
