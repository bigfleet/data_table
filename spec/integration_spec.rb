require File.dirname(__FILE__) + '/spec_helper'

describe TestController, "When integrating with Rails" do
  
  before(:each) do
    @controller = MockController.new
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