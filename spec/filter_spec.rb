require File.dirname(__FILE__) + '/spec_helper'

describe "A filter" do
  
  before(:each) do
    @f = Filter.new
  end
  
  it "should consist of a set of filter elements"
  
  it "should allow filter elements to be added"
  
  it "should produce a hash of selected options"
  
  it "should be skinnable"
  
  it "should ensure filter elements are serialized along with sort options"
  
  it "should allow for choosing between AJAX and non-AJAX modes"
  
  it "should allow setting the default AJAX mode"
  
  describe "when fully initialized" do
    before(:each) do
      @f = Filter.spec(:name => :testing ) do |f|
        f.element(:etype) do |e|
          e.default  "Equities + Options", nil
          e.option   "Equities",          'stock'
          e.option   "Options",           'option'
        end
      end
    end
    
    it "should have one element" do
      @f.elements.should have_at_least(1).things
    end
    
    it "should register no active elements" do
      @f.active_elements.should_not be_nil
      @f.active_elements.should be_empty
    end
    
    it "should be referenced by it's elements" do
      @f.elements.each {|elt| elt.parent.should == @f} 
    end
    
    it "should not yield any selected options without params"
    
    describe "and with input parameters" do
      
      before(:each) do
        @params = {}
        @params[:filter] = {}
        @params[:filter][:testing] = {}
        @params[:filter][:testing][:etype] = 'equities'
      end
      
      it "should register an active element" do
        active_elts = @f.active_elements(@params[:filter][:testing])
        active_elts.should_not be_nil
        active_elts.should_not be_empty
        active_elts.should have(1).things
      end
      
      it "should yield the expected options" do
        @f.conditions(@params).should == {:etype => "stock"}
      end
      
    end
    
  end
  
end