require File.dirname(__FILE__) + '/spec_helper'

# Some day, when this project is all grown up, I envision different spec
# files for the different kinds of filtering that can be done, with a
# special file to tax the limits and integrate bugs into.  For now, it's
# all in this spec

describe FilterController, "When integrating with Rails" do
  
  before(:each) do
    @controller = FilterController.new
  end
  
  describe "a simulated request with no parameters" do
    
    before(:each) do
      @controller.basic_filter
      @conditions = @controller.conditions_for(:cars)
    end
    
    it "should have no conditions when not provided with params" do
      @conditions.should be_nil
    end
    
    it "should not error when rendering the filter form"
    
    it "should render a default option as selected"
    
    it "should indicate no special sorting"
    
    it "should retrieve the first page of listings"
    
    it "should contain links to the second page of listings"
    
  end
  
  describe "a simulated request with parameters" do
    
    #?most_traded%5Betype%5D=all&most_traded%5Btraded_at%5D=15-days
    
    before(:each) do
      @controller.params = {:cars => {:colors => 'blue' }}
      @controller.basic_filter
      @conditions = @controller.conditions_for(:cars)
    end
    
    it "should yield AR-ready conditions" do
      @conditions.should_not be_nil
    end
    
    it "should yield an appropriate options hash" do
      
    end
    
    it "should not error when rendering the filter form"
    
    it "should no longer render the default option as selected"

    it "should choose the parameter selection option as selected"
    
    it "should indicate no special sorting"
    
    it "should retrieve the first page of listings"
    
    it "should contain links to the second page of listings"
    
  end
  
end