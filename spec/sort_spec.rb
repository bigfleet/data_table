require File.dirname(__FILE__) + '/spec_helper'

describe "A filter-attached sort" do
   
  describe "when fully initialized" do
    before(:each) do
      @s = Sort.new
      @default = @s.default 'make'
      @other = @s.option  'year', 'desc'
    end
    
    describe "with default sort" do
      
      it "should store the default option correctly" do
        @s.default_option.should == @default
        @s.selected.should == @s.default_option
      end
      
      it "should be aware of its current sort ordering" do
        @s.selected.current_order.should == 'asc'
      end
      
      it "should register correct default ordering" do
        @s.selected.other_order.should == 'desc'
      end
      
      
    end
    
    describe "with alternate default sort" do
      
      before(:each) do
        @s = @s.with({:sort_key => 'make', :sort_order => 'desc'})
      end
      
      it "should not change the selected option for alternate default sort" do
        @s.selected.should == @s.default_option
      end
      
      it "should be aware of its current sort ordering" do
        @s.selected.current_order.should == 'desc'
      end
      
      it "should register correct default ordering" do
        @s.selected.other_order.should == 'asc'
      end
      
    end
    
    describe "when sorting a secondary sort in preferred mode" do
      
      before(:each) do
        @s = @s.with({:sort_key => 'year', :sort_order => 'desc'})
      end
      
      it "should not change the selected option for alternate default sort" do
        @s.selected.should_not == @s.default_option
      end
      
      it "should be aware of its current sort ordering" do
        @s.selected.current_order.should == 'desc'
      end
      
      it "should register correct default ordering" do
        @s.selected.other_order.should == 'asc'
      end
      
    end
    
    describe "when sorting a secondary sort in alternate mode" do
      
      before(:each) do
        @s = @s.with({:sort_key => 'year', :sort_order => 'asc'})
      end
      
      it "should not change the selected option for alternate default sort" do
        @s.selected.should_not == @s.default_option
      end
      
      it "should be aware of its current sort ordering" do
        @s.selected.current_order.should == 'asc'
      end
      
      it "should register correct default ordering" do
        @s.selected.other_order.should == 'desc'
      end
      
    end    
    
  end
    
end