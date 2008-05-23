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
    
    it "should not error when rendering the filter form" do
      @controller.filter_form(:cars).should_not be_nil
    end
    
    it "should render a default option as selected" do
      @controller.filter_form(:cars).should match(/<option value=\"all\" selected/)
    end
    
    it "should render a sort header" do
      @controller.sort_header(:cars).should_not be_nil
    end
    
    it "should indicate that make is currently sorted in ascending order" do
      @controller.sort_header(:cars).should =~ /<img alt=\"Sort by Make\" src=\"(.+)sort_asc.gif/
    end
    
    it "should have a click on make sort in descending order" do
      @controller.sort_header(:cars).should =~ /\?key=make&order=desc/
    end
    
    it "should have the first request to sort by year be in descending order" do
      @controller.sort_header(:cars).should =~ /\?key=year&order=desc/
    end
        
  end
  
end