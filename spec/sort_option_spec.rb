require File.dirname(__FILE__) + '/spec_helper'

describe "A sorting option" do
  
  describe "in its basic structure" do
    
    before(:each) do
      @f = Filter.new(:name => :cars)
      @sort = Sort.new
      @default = @sort.default 'make'
      @option = @sort.option  'year', 'desc'
      @f.sort = @sort
    end
    
    it "should know of its parent sort specification" do
      @default.parent.should == @sort
    end

    it "should be affiliated with a certain sort key" do
      @default.key.should == 'make'
    end
    
    it "should reflect no current ordering by default" do
      @default.current_order.should == 'asc'
      @option.current_order.should be_nil
    end
    
    it "should reflect the preferred ordering as current when active" do
      @sort.selected = @default
      @default.current_order.should == 'asc'
    end
        
    it "should respect a preferred sort order" do
      @default.preferred_order.should == 'asc'
    end
    
    it "should support an 'only' order option"
    # so that it is either unsorted or in preferred order
    
    it "should be aware if it is selected or not" do
      @option.should_not be_active
      @sort.selected = @option
      @option.should be_active
    end
    
    it "should be aware of the alternate ordering to the current order" do
      @sort.selected = @default
      @default.other_order.should == 'desc'
    end
    
  end
  
end