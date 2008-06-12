require File.dirname(__FILE__) + '/spec_helper'

describe "A filter element" do
  
  before(:each) do
    @fe = FilterElement.new
  end
  
  it "should retain an association to the filter of which it's a part" do
    @fe.parent = Filter.new
    @fe.parent.should be_a_kind_of( Filter )
  end
  
  describe "at initialization" do
    
    it "should be initializable with a symbol, in the simple case" do
      fe = FilterElement.new(:etype)
      fe.field.should == :etype
    end
    
    it "should be initializable with a symbol, in the complicated case" do
      fe = FilterElement.new(:field => :etype, :table => :equities)
      fe.table.should == :equities
      fe.field.should == :etype
    end
    
  end
  
  describe "fully defined" do
    
    before(:each) do
      parent_filter = Filter.new(:name => :testing)
      @fe = FilterElement.new(:etype)
      @fe.parent = parent_filter
      @default = (@fe.default  "Equities + Options", nil)
      @option1 = (@fe.option   "Equities",          'stock')
      @option2 = (@fe.option   "Options",           'option')
    end
    
    it "should have three total options registered" do
      @fe.selections.should_not be_nil
      @fe.selections.should_not be_empty
      @fe.selections.should have(3).things
    end
    
    it "should recognize the default option" do
      @fe.selected.should == @default
    end
    
    it "should not indicate that this element should be included in filter options" do
      @fe.should_not be_active
    end

    describe "in the presence of selected parameters" do
      
      before(:each) do
        @params = {:etype => "equities"}
        @fe = @fe.with(@params)
      end
      
      it "should have three total options registered" do
        @fe.selections.should_not be_nil
        @fe.selections.should_not be_empty
        @fe.selections.should have(3).things
      end
      
      it "should indicate that this element should be included in filter options" do
        @fe.should be_active
      end
      
      it "should select based on parameter" do
        @fe.selected.should equal(@option1)
      end
      
      it "should use the selection phrase, not the titleized label for conditions" do
        @fe.to_hash.should == {:etype => 'stock'}
      end

    end
    
  end
    
end