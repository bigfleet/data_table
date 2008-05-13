require File.dirname(__FILE__) + '/spec_helper'

#Some day, when this project is all grown up, I envision different spec
# files for the different kinds of filtering that can be done, with a
# special file to tax the limits and integrate bugs into.  For now, it's
# all in this spec

describe FilterController, "When integrating with Rails" do
  
  before(:each) do
    @controller = FilterController.new
  end
  
  describe "this test" do
    
    it "should recognize the controller" do
      @controller.should_not be_nil
    end
    
    it "should add expected methods to the controller" do
      @controller.respond_to?(:conditions_for).should == true
      @controller.respond_to?(:filter_spec).should == true
    end
    
  end
  
  describe "a simulated request with no parameters" do
    
    before(:each) do
      @controller.basic_filter
      @conditions = @controller.conditions_for(:cars)
    end
    
    it "should have no conditions when not provided with params" do
      @conditions.should be_nil
    end
    
  end
  
  describe "a simulated request with parameters" do
    
    before(:each) do
      @controller.basic_filter
      @controller.params = {:filter => {:cars => 'equities'}}
      @conditions = @controller.conditions_for(:cars)
    end
    
    it "should have no conditions when not provided with params" do
      @conditions.should_not be_nil
    end
    
  end
  
end