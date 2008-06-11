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
    
  end
  
  describe "when specified in usual format" do
    
    before(:each) do
      @old_f = Filter.spec(:name => :cars) do |f|
        f.element(:color) do |e|
          e.default "All"
          e.option  "Blue"
          e.option  "Red"
          e.option  "Silver"
          e.option  "Black"
          e.option  "Other"
          e.option  "Polka Dot", "plka-dot"
        end
      end
      @params = {:cars => {:color => "blue"}}
    end
    
    describe "when transforming itself with parameters" do
      
      before(:each) do
        @new_f = @old_f.with(@params)
      end
      
      it "should have the same number of elements" do
        @new_f.elements.size.should == @old_f.elements.size
      end

      it "should reflect the change in selection for elements" do
        @new_f.elements.first.should be_active
      end
      
      
    end
    
    describe "its ActiveRecord friendly conditions" do

      it "should expose nothing without access to parameters" do
        @old_f.conditions.should be_nil
      end

      it "should expose the original parameters when available" do
        @new_f = @old_f.with(@params)
        @new_f.conditions.should == ["color = ?", "blue"]
      end
      
      it "should utilize the value phrase, not the titlized label" do
        @new_f = @old_f.with({:cars => {:color => "polka-dot"}})
        @new_f.conditions.should == ["color = ?", "plka-dot"]
      end

    end

    describe "its flexibile options hash" do

      it "should expose nothing without access to parameters" do
        @old_f.options.should == {:color => nil}
      end

      it "should expose the original parameters when available" do
        @new_f = @old_f.with(@params)
        @new_f.options.should == {:color => "blue"}
      end
      
      it "should utilize the value phrase, not the titlized label" do
        @new_f = @old_f.with({:cars => {:color => "polka-dot"}})
        @new_f.options.should == {:color => "plka-dot"}
      end

    end
    
  end
  
end