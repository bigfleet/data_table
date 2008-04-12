require File.dirname(__FILE__) + '/spec_helper'

describe "When integrating with Rails" do
  
  before(:each) do
    class TestController < ActionController::Base
      def index
        Filter.spec(:name => :testing ) do |f|
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
      @controller.respond_to?(:filter_conditions).should == true
    end
    
  end
  
end