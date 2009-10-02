class Employee < ActiveRecord::Base
  
  named_scope :boss, :conditions => "position = 'Boss'"
  named_scope :country, lambda { |country| { :conditions => ["country = ?", country] } }

end

20.times do |n|
  position  = (n == 0) ? "Boss" : "Worker"
  salary    = (n == 0) ? 100000 : (((n+1) % 5) * 10000)
  Employee.create(:name => "Employee #{n}", :country => "Country #{(n % 10) + 1}", :position => position, :salary => salary)
end

#puts Employee.all.inspect
