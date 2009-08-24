$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

require 'filter_fu'

Spec::Runner.configure do |config|

end

ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), 'debug.log'))

configuration = YAML.load_file(File.join(File.dirname(__FILE__), 'db', 'database.yml'))
ActiveRecord::Base.establish_connection(configuration[ENV["DB"] || "sqlite3"])

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load(File.join(File.dirname(__FILE__), "db", "schema.rb"))
end