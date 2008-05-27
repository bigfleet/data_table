require File.dirname(__FILE__) + '/spec_helper'

describe "A filter" do
  
  before(:each) do
    @f = Filter.new
  end
  
  describe "and its basic structure" do
  
    it "should allow filter elements to be added" do
      @f.element(:color) do |e|
        e.default "Any"
      end
      @f.elements.should have(1).things
    end
    
    it "should allow for choosing between AJAX modes" do
      ajax = Filter.new(:name => :testing, :mode => :ajax)
      ajax.mode.should == :ajax
    end
    
    it "should allow for choosing between AJAX modes" do
      non_ajax = Filter.new(:name => :testing)
      non_ajax.mode.should == :standard
    end

    it "should allow setting the default AJAX mode on an application wide level"
    
  end
  
  describe "when transforming itself" do
    
    before(:each) do
      @old_f = Filter.spec(:name => :cars) do |f|
        f.element(:color) do |e|
          e.default "All"
          e.option  "Blue"
          e.option  "Red"
          e.option  "Silver"
          e.option  "Black"
          e.option  "Other"
        end
      end
      @params = {:cars => {:color => "blue"}}
      @new_f = @old_f.with(@params)
    end
    
    it "should transfer its name successfully" do
      @new_f.name.should == @old_f.name
    end
    
    it "should transfer the operation mode successfully" do
      @new_f.mode.should == @old_f.mode
    end
    
    it "should have the same number of elements" do
      @new_f.elements.size.should == @old_f.elements.size
    end
    
    it "should reflect the change in selection for elements" do
      @new_f.elements.first.should be_active
    end
    
  end
  
  describe "and its ActiveRecord friendly conditions" do
    
    describe "without access to parameters" do
    end
    
    describe "with access to parameters" do
    end
    
  end
  
  describe "and its flexibile options hash" do
    
    describe "without access to parameters" do
    end
    
    describe "with access to parameters" do
      
      it "should register an active element"
      
      it "should yield the expected conditions"

      it "should yield the expected options"
      
    end
    
  end
  
  describe "when including a sort specification" do
    
    it "should ensure filter elements are serialized along with sort options"
    
  end
  
end