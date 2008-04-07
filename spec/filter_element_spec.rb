require File.dirname(__FILE__) + '/spec_helper'

describe "A filter element" do
  
  before(:each) do
    @fe = FilterElement.new
  end
  
  it "should retain an association to the filter of which it's a part"
  
  it "should allow specification of which table is to be filtered" do
    @fe.table = "users"
    @fe.table.should == "users"
  end
  
  it "should store the field to be filtered" do
    @fe.field = "first_name"
    @fe.field.should == "first_name"
  end
  
  it "should support comparison filtration" do
    @fe.operator = ">="
    @fe.operator.should == ">="
  end
  
  it "should support between filtration" do
    @fe.operator = "BETWEEN"
    @fe.operator.should == "BETWEEN"
  end
  
  it "should support equality filtration" do
    @fe.operator.should == "="
  end
  
  it "should support similarity filtration" do
    @fe.operator = "LIKE"
    @fe.operator.should == "LIKE"
  end
  
  it "should allow specification of which filter is selected" do
    fs = DefaultFilterSelection.new("buyopen")
    fs.label = "Buy To Open"
    @fe.selected = fs
    @fe.selected.should == fs
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
      @fe = FilterElement.new(:etype)
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
    
    it "should render an appropriately selected HTML tag" do
      @fe.to_html.should_not be_nil
    end
    
    it "should have the HTML tag specced out a great deal more"
    
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
        @fe.selected.should == @option1
      end
      
      it "should render an appropriately selected HTML tag"  do
        @fe.to_html.should_not be_nil
      end
      
      it "should have the HTML tag specced out a great deal more"
      
    end
    
  end
    
end

describe "A time filtration element" do
  
  it "should allow specification of which table is to be filtered"
  
  it "should store the field to be filtered"
  
  it "should support comparison filtration"
  
  it "should support between filtration"
  
  it "should support equality filtration"
  
  it "should support similarity filtration"
  
  it "should allow specification of which filter is selected"
    
end