require File.dirname(__FILE__) + '/spec_helper'

describe "A filter element" do
  
  before(:each) do
    @fe = FilterElement.new
  end
  
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
  
  describe "fully defined" do
    
    before(:each) do
      @fe.default  "Equities + Options", nil
      @fe.option   "Equities",          'stock'
      @fe.option   "Options",           'option'
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