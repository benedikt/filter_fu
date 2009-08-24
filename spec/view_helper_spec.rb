require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'dummies'

describe FilterFu::ViewHelper, :type => :helper do
  
  before(:each) do
    @controller  = DummyController.new
    @request     = @controller.request
    
    helper.controller = @controller
    helper.request = @request
    
    helper.output_buffer = ""
  end

  it "should provide a filter_form_for method" do
    helper.should respond_to(:filter_form_for)
  end
  
  it "should require a block" do
    lambda { helper.filter_form_for }.should raise_error(ArgumentError, /Missing block/)
  end
  
  it "should accept options" do
    lambda { helper.filter_form_for({}) {} }.should_not raise_error(ArgumentError)
  end
  
  it "should not require options" do
    lambda { helper.filter_form_for() {} }.should_not raise_error(ArgumentError)
  end
  
  it "should accept a name together with options" do
    lambda { helper.filter_form_for(:other, {}) {} }.should_not raise_error(ArgumentError)
  end
  
  it "should call the associated block" do
    lambda {
      helper.filter_form_for() { throw :done }
    }.should throw_symbol(:done)
  end
  
  it "should pass a ActionView::Helpers::FormBuilder to the block" do
    helper.filter_form_for { |f| f.should be_kind_of(ActionView::Helpers::FormBuilder) }
  end
  
  it "should include the erb of the block" do
    html = eval_erb("<% filter_form_for { %><div>Some random HTML</div><% } %>")
    html.should have_tag('div', 'Some random HTML')
  end
  
  it "should include a form tag" do
    html = eval_erb("<% filter_form_for { %> <% } %>")
    html.should have_tag('form')
  end
  
  it "should set the form method attribute to GET" do
    html = eval_erb("<% filter_form_for { %> <% } %>")  
    html.should have_tag('form[method=?]', 'get')
  end
  
  it "should set the form action attribute to the current url" do
    # Controller and Action are foo and bar as defined in the dummies
    html = eval_erb("<% filter_form_for { %> <% } %>")  
    html.should have_tag('form[action=?]', '/foo/bar')
  end
  
  it "should use :filter as the default namespace in form fields" do
    html = eval_erb("<% filter_form_for { |f| %><%= f.text_field :name %><% } %>")
    html.should have_tag('input[name=?]', 'filter[name]')
  end
  
  it "should use another name as namespace if it's provided as the first argument" do
    html = eval_erb("<% filter_form_for(:other) { |f| %><%= f.text_field :name %><% } %>")
    html.should have_tag('input[name=?]', 'other[name]')
  end
  
  it "should pass options to the form_for helper" do
    html = eval_erb("<% filter_form_for(:html => { :class => 'filter' }) { |f| %> <% } %>")
    html.should have_tag('form[class=?]', 'filter')
  end
  
  it "should preserve the page's parameters with hidden fields" do
    helper.params = { :some_param => 'some value', :some_other_param => 'some other value' }
    html = eval_erb("<% filter_form_for() { |f| %> <% } %>")
    html.should have_tag('input[type=?][name=?][value=?]', 'hidden', 'some_param', 'some value')
    html.should have_tag('input[type=?][name=?][value=?]', 'hidden', 'some_other_param', 'some other value')
  end
  
  it "should preserve the page's nested parameters with hidden fields" do
    helper.params = { :some_param => 'some value', :nested => { :some_other_param => 'some other value', :deeply_nested => { :down_here => 'yet another value' } } }
    html = eval_erb("<% filter_form_for() { |f| %> <% } %>")
    html.should have_tag('input[type=?][name=?][value=?]', 'hidden', 'some_param', 'some value')
    html.should have_tag('input[type=?][name=?][value=?]', 'hidden', 'nested[some_other_param]', 'some other value')
    html.should have_tag('input[type=?][name=?][value=?]', 'hidden', 'nested[deeply_nested][down_here]', 'yet another value')
  end
  
  it "should not preserve the page's parameters for the current filter" do
    helper.params = { :other => { :name => 'some value' }}
    html = eval_erb("<% filter_form_for(:other) { |f| %> <% } %>")
    html.should_not have_tag('input[type=?][name=?]', 'hidden', 'other')
    html.should_not have_tag('input[type=?][name=?][value=?]', 'hidden', 'other[name]', 'some value')
  end
  
  it "should not preserve the controller and action params" do
    helper.params = { :controller => 'foo', :action => 'bar' }
    html = eval_erb("<% filter_form_for() { |f| %> <% } %>")
    html.should_not have_tag('input[type=?][name=?][value=?]', 'hidden', 'controller', 'foo')
    html.should_not have_tag('input[type=?][name=?][value=?]', 'hidden', 'action', 'bar')
  end
  
  it "should not preserve params specified in :ignore_parameters" do
    helper.params = { :some_param => 'some value', :some_other_param => 'some other value' }
    html = eval_erb("<% filter_form_for(:ignore_parameters => [:some_other_param]) { |f| %> <% } %>")
    html.should have_tag('input[type=?][name=?][value=?]', 'hidden', 'some_param', 'some value')
    html.should_not have_tag('input[type=?][name=?][value=?]', 'hidden', 'some_other_param', 'some other value')
  end
  
  it "should use the current filter params as defaults for the form" do
    helper.params = { :filter => { :some_param => 'some value' } }
    html = eval_erb("<% filter_form_for() { |f| %><%= f.text_field :some_param %><% } %>")
    html.should have_tag('input[type=?][name=?][value=?]', 'text', 'filter[some_param]', 'some value')
  end
end