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
    
    it "should default to Ajax mode" do
      ajax = Filter.new(:name => :testing)
      ajax.mode.should == :ajax
    end
    
    it "should allow for choosing standard mode" do
      non_ajax = Filter.new(:name => :testing, :mode => :standard)
      non_ajax.mode.should == :standard
    end

    it "should allow setting the default AJAX mode on an application wide level"
    
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

    describe "its exposed parameters for url formation" do

      it "should expose nothing without access to parameters" do
        @old_f.exposed_params.should == {}
      end

      it "should expose the original parameters when available" do
        @new_f = @old_f.with(@params)
        @new_f.exposed_params.should == @params
      end
      
      it "should flatten the exposed parameters appropriately" do
        @new_f = @old_f.with(@params)
        @new_f.exposed_params.flatten_one_level.should == {"cars[color]"=>"blue"}
      end

    end
    
  end
  

  
end