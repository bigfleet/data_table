require File.dirname(__FILE__) + '/spec_helper'

describe "A filter-attached sort" do
   
  describe "when fully initialized" do
    before(:each) do
      @f = Filter.new(:name => :cars)
      @s = Sort.new
      @default = @s.default 'make'
      @other = @s.option  'year', 'desc'
      @f.sort = @s
    end
        
    it "should store the default option correctly" do
      @s.default_option.should == @default
      @s.selected.should == @s.default_option
    end
    
    it "should not change the selected option for alternate default sort" do
      @s = @s.with(:key => 'make', :order => 'desc')
      @s.selected.should == @s.default_option
    end
    
    it "should change the selected option for alternate sort" do
      @s = @s.with(:key => 'year', :order => 'desc')
      @s.selected.should_not == @s.default_option
      @s.selected.should == @other
    end
    
    
  end
    
end