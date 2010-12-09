# Taken from mislav's will_paginate http://github.com/mislav/will_paginate/tree/master

class DummyController < ActionView::TestCase::TestController
  def initialize
    super
    @params.merge!(:controller => 'foo', :action => 'bar')
    @request.path_parameters = @params
  end
end

Rails.application.routes.draw do
  match "foo/bar", :controller => 'foo', :action => 'bar'
end