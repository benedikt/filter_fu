%w(active_record view_helper).each { |file| require File.join(File.dirname(__FILE__), 'filter_fu', file) }

ActiveRecord::Base.send :include, FilterFu::ActiveRecord
ActionView::Base.send   :include, FilterFu::ViewHelper