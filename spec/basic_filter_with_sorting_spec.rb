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
      @params = {}
      @controller.basic_filter_with_sorting
      @filter = @controller.find_filter(:cars).with(@params)
      @conditions = @filter.conditions
      @options = @filter.options
    end
    
    it "should have no active elements" do
      @filter.active_elements.should be_empty
    end
    
    it "should have no conditions" do
      @conditions.should be_nil
    end
    
    it "should have a sparse set of options" do
      @options.should_not be_nil
      @options.should == {:color => nil}
    end
        
  end
  
  describe "a simulated request with filtering parameters" do
    
    before(:each) do
      @params = {:cars => {:color => "blue"}}
      @controller.basic_filter_with_sorting
      @filter = @controller.find_filter(:cars).with(@params)
      @conditions = @filter.conditions
      @options = @filter.options
    end
    
    it "should have activated some elements" do
      @filter.active_elements.should_not be_nil
    end
    
    it "should have conditions ready for ActiveRecords" do
      @conditions.should_not be_nil
      @conditions.should == ["color = ?", "blue"]
    end
    
    it "should have a populated set of options" do
      @options.should_not be_nil
      @options.should == {:color => "blue"}
    end
        
  end
  
end