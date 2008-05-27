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
      @controller.params = {}
      @controller.basic_filter_with_sorting
      @conditions = @controller.conditions_for(:cars)
      @options = @controller.options_for(:cars)
    end
    
    it "should have no conditions" do
      @conditions.should be_nil
    end
    
    it "should have a sparse set of options" do
      @options.should_not be_nil
      @options.should == {:colors => nil}
    end
        
  end
  
end