require File.dirname(__FILE__) + '/spec_helper'

describe "When integrating with Rails" do
  
  before(:each) do
    class TestController < ActionController::Base
      uses_data_table
      def index
        filter_spec(:name => :testing) do |f|
          f.element(:etype) do |e|
            e.default  "Equities + Options", nil
            e.option   "Equities",          'stock'
            e.option   "Options",           'option'
          end
        end
      end
    end
    @controller = TestController.new
  end
  
  describe "this test" do
    
    it "should recognize the controller" do
      @controller.should_not be_nil
      @controller.is_a?(TestController).should == true
    end
    
    it "should add expected methods to the controller" do
      @controller.respond_to?(:conditions_for).should == true
      @controller.respond_to?(:filter_spec).should == true
    end
    
  end
  
  describe "a simulated request with no parameters" do
    
    before(:each) do
      @controller.index #simulate a request
      @conditions = @controller.conditions_for(:testing)
    end
    
    it "should have no conditions when not provided with params" do
      @conditions.should be_nil
    end
    
  end
  
  describe "a simulated request with parameters" do
    
    before(:each) do
      @controller.index #simulate a request
      @controller.params = {:filter => {:testing => 'equities'}}
      @conditions = @controller.conditions_for(:testing)
    end
    
    it "should have no conditions when not provided with params" do
      @conditions.should_not be_nil
    end
    
  end
  
end