require 'spec_helper'

describe FilterFu::ActiveRecord do

  it "should add a filter_fu class method to ActiveRecord::Base" do
    ActiveRecord::Base.should respond_to(:filter_fu)
  end

  describe "-filter_fu" do

    it "should accept an options hash" do
      lambda { ActiveRecord::Base.filter_fu({}) }.should_not raise_error(ArgumentError)
    end

    it "should not require an options hash" do
      lambda { ActiveRecord::Base.filter_fu }.should_not raise_error(ArgumentError)
    end

    it "should add a new singleton method called filtered_by" do
      Employee.should respond_to(:filtered_by)
    end

    it "should not accept invalid options" do
      lambda { ActiveRecord::Base.filter_fu(:invalid_option => 'some value') }.should raise_error
    end

    %w(only except).each do |option|
      it "should accept :#{option} as an option" do
        lambda { ActiveRecord::Base.filter_fu(option => 'some value') }.should_not raise_error
      end
    end

    it "should not accept :except and :only option at the same time" do
      lambda { ActiveRecord::Base.filter_fu(:only => 'some value', :except => 'some other value') }.should raise_error(/Use either :only or :except/)
    end

  end

  describe "-filtered_by" do

    before(:each) do
      @plain_class = Class.new(Employee)
      @class = @plain_class.clone
      @class.filter_fu if @class.respond_to?(:filter_fu)
    end

    it "should require a hash with filter params" do
      lambda { @class.filtered_by }.should raise_error(ArgumentError)
    end

    it "should not fail if the hash with filter params is nil" do
      lambda { @class.filtered_by(nil) }.should_not raise_error(NoMethodError)
    end

    it "should not filter anything if the hash is nil" do
      @class.filtered_by(nil).should == @class.all
    end

    it "should not filter anything if the hash is empty" do
      @class.filtered_by({}).should == @class.all
    end

    it "should not return nil if all scopes were skipped" do
      # This is ugly. Is there a better solution to this?
      klass = @plain_class.filter_fu :only => :salary
      klass.filtered_by({ :country => 'Whatever' }).should_not be_nil
    end

    it "should handle HashWithIndifferentAccess correctly" do
      @class.filtered_by(HashWithIndifferentAccess.new('salary' => 100000)).should == @class.all(:conditions => 'salary = 100000')
      @class.filtered_by(HashWithIndifferentAccess.new('boss' => true)).should == @class.all(:conditions => "position = 'Boss'")
    end

    it "should return an instace of ActiveRecord::NamedScope::Scope" do
      @class.filtered_by({ :boss => nil }).class.should == ActiveRecord::Relation
    end

    it "should call named scopes if specified in the filter params" do
      @class.should_receive(:boss)
      @class.filtered_by({ :boss => '' })
    end

    it "should pass the value to the named scope" do
      @class.should_receive(:country).with('some value')
      @class.filtered_by({ :country => 'some value'})
    end

    it "should only call the specified named scope if it is available" do
      @class.should_not_receive(:unavailable)
      @class.filtered_by({ :unavailable => '' })
    end

    it "should allow multiple scopes at once and combine them" do
      @class.filtered_by({ :position => 'Worker', :country => 'Country 1'}).should == @class.all(:conditions => { :position => 'Worker', :country => 'Country 1'})
    end

    describe "when the given named scope is not available" do

      it "should create an anonymous scope using the filter options as conditions" do
        @class.filtered_by(:salary => 100000).should == @class.all(:conditions => 'salary = 100000')
      end

      it "should not create an anonymous scope if there is no column for it" do
        lambda { @class.filtered_by(:non_existing_column => 'some value').all }.should_not raise_error(/no such column/)
      end

      it "should not create an anonymous scope if the value is blank" do
        @class.filtered_by(:salary => '').should == @class.all()
      end

      it "should create an anonymous scope that is able to handle an array of possible values for the filter" do
        @class.filtered_by(:salary => [80000, 90000]).should == @class.all(:conditions => 'salary IN (80000, 90000)')
      end

    end

    it "should not filter by scopes defined in :except option" do
      klass = @plain_class.clone
      klass.filter_fu :except => :dont_access_me
      klass.scope :dont_access_me, {}
      klass.scope :access_me, {}

      klass.should_not_receive(:dont_access_me)
      klass.filtered_by(:dont_access_me => '')
    end

    it "should filter by scopes not defined in :except option" do
      klass = @plain_class.clone
      klass.filter_fu :except => :dont_access_me
      klass.scope :dont_access_me, {}
      klass.scope :access_me, {}

      klass.should_receive(:access_me)
      klass.filtered_by(:access_me => '')
    end

    it "should only filter by scopes define in :only option" do
      klass = @plain_class.clone
      klass.filter_fu :only => :only_access_me
      klass.scope :only_access_me, {}
      klass.scope :dont_access_me, {}

      klass.should_receive(:only_access_me)
      klass.filtered_by(:only_access_me => '')
    end

    it "should not filter by scopes not defined in :only option" do
      klass = @plain_class.clone
      klass.filter_fu :only => :only_access_me
      klass.scope :only_access_me, {}
      klass.scope :dont_access_me, {}

      klass.should_not_receive(:dont_access_me)
      klass.filtered_by(:dont_access_me => '')
    end
  end

end
