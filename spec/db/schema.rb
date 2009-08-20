ActiveRecord::Schema.define(:version => 0) do

  create_table :employees, :force => true do |t|
    t.string  :name
    t.string  :country
    t.string  :position
    t.integer :salary
  end
  
end