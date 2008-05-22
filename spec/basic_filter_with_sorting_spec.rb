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
      @controller.basic_filter_with_sorting
      @conditions = @controller.conditions_for(:cars)
    end
    
    it "should have no conditions when not provided with params" do
      @conditions.should be_nil
    end
    
    it "should not error when rendering the filter form" do
      @controller.filter_form(:cars).should_not be_nil
    end
    
    it "should render a default option as selected" do
      @controller.filter_form(:cars).should match(/<option value=\"all\" selected/)
    end
    
    it "should have a default sorting by make"
    
    it "should have the first request to sort by year be in descending order"
        
  end
  
end