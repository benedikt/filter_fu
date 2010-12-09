require 'filter_fu/active_record'
require 'filter_fu/view_helper'

module FilterFu
  class Railtie < Rails::Railtie

    initializer "filter_fu.initialize" do |app|
      ::ActiveRecord::Base.send :include, FilterFu::ActiveRecord if defined? ::ActiveRecord::Base
      ::ActionView::Base.send   :include, FilterFu::ViewHelper if defined? ::ActionView::Base
    end
  end
end
