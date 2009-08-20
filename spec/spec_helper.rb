$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'actionpack' 
require 'activerecord'
require 'action_view'

require 'filter_fu'
require 'spec'
require 'spec/autorun'
#gem 'rspec-rails'



Spec::Runner.configure do |config|

end

ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), 'debug.log'))

configuration = YAML.load_file(File.join(File.dirname(__FILE__), 'db', 'database.yml'))
ActiveRecord::Base.establish_connection(configuration[ENV["DB"] || "sqlite3"])

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load(File.join(File.dirname(__FILE__), "db", "schema.rb"))
end