require File.dirname(__FILE__) + '/spec_helper'

describe "A sorting option" do
  
  describe "in its basic structure" do
    
    before(:each) do
      @sort = Sort.new
      @default = SortOption.new(@sort, :make)
    end
    
    it "should know of its parent sort specification" do
      @default.parent.should == @sort
    end

    it "should be affiliated with a certain sort key" do
      @default.key.should == :make
    end
    
    it "should reflect a current sort order"
    
    it "should respect a preferred sort order" do
      @default.preferred_order.should == 'asc'
    end
    
    it "should support an 'only' order option"
    # so that it is either unsorted or in preferred order
    
  end
  
end