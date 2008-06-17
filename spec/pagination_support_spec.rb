require File.dirname(__FILE__) + '/spec_helper'

describe DataTable::PaginationSupport do
  
  uses_data_table
  
  before(:each) do
    data_table(:cars) do |table|
      table.sort_spec do |s|
        s.default 'make'
        s.option  'year', 'desc'
      end
      table.filter_spec do |f|
        f.element(:color) do |e|
          e.default "All"
          e.option  "Blue"
          e.option  "Red"
          e.option  "Silver"
          e.option  "Black"
          e.option  "Other"
        end
      end
    end
    @cars = data_table(:cars)
    @params = {}
    @opts = {:remote => {:url => '/cars/hottest_sellers', :update => 'hotBox', :method => "get"}, 
    :with => [:tab] }
    @data_tables = {}
  end

  
  describe "with no parameters" do
    
    describe "the standard url" do
      it "should include only the page" do
        @cars.pagination_url_for(2).should == "?page=2"
      end
    end
    
    describe "the remote url options" do
      
      before(:each) do
        @cars.options = @opts
      end
      
      it "should include only the page in the url" do
        @cars.remote_pagination_options_for(2)[:url].should match(/page=2/)
      end
      
      it "should respect the other appropriate remote options" do
        @cars.remote_pagination_options_for(2).should == 
          {:url => "/cars/hottest_sellers?page=2", :update => 'hotBox', :method => "get"}
      end
    end
    
  end
  
  describe "with parameters for sorting" do
    
    before(:each) do
      @params = {:cars => {:sort_key => "year", :sort_order => "desc"}}
      @cars.params = @params
    end
    
    describe "the standard url" do
      it "should include the page and the sorting options" do
        @cars.pagination_url_for(2).should == "?page=2&cars[sort_order]=desc&cars[sort_key]=year"
      end
    end
    
    describe "the remote url options" do
      
      before(:each) do
        @cars.options = @opts
      end
      
      it "should include the page and the sorting options" do
        @cars.remote_pagination_options_for(2)[:url].should match(/page=2/)
      end
      it "should respect the other appropriate remote options" do
         @cars.remote_pagination_options_for(2).should == 
            {:url => "/cars/hottest_sellers?page=2&cars[sort_order]=desc&cars[sort_key]=year", 
              :update => 'hotBox', :method => "get"}
      end
    end
    
  end
  
  describe "with parameters for filtering" do
    
    
    describe "the standard url" do
      it "should include the page and the filtering options"
    end
    
    describe "the remote url options" do
      it "should include the page and the filtering options"
      it "should respect the other appropriate remote options"
    end
    
  end
  
  describe "with parameters for filtering and sorting" do
    
    
    describe "the standard url" do
      it "should include the page and all appropriate options"
    end
    
    describe "the remote url options" do
      it "should include the page and all appropriate options"
      it "should respect the other appropriate remote options"
    end
    
  end
  
end