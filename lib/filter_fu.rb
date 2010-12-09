require 'filter_fu/active_record'
require 'filter_fu/view_helper'

module FilterFu
  mattr_accessor :ignore_parameters
  @@ignore_parameters = []

  class Railtie < Rails::Railtie
    config.filter_fu = FilterFu

    initializer "filter_fu.initialize" do |app|
      ::ActiveRecord::Base.send :include, FilterFu::ActiveRecord if defined? ::ActiveRecord::Base
      ::ActionView::Base.send   :include, FilterFu::ViewHelper if defined? ::ActionView::Base
    end
  end
end
