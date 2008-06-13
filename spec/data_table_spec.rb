require File.dirname(__FILE__) + '/spec_helper'

describe "a data_table" do
  
  uses_data_table
    
  it "should define a data_table method" do
    self.should respond_to(:data_table)
  end
  
  it "should have optional sorting" do
    data_table(:cars) do |table|
      table.sort_spec do |s|
        s.default 'make'
        s.option  'year', 'desc'
      end
    end
    @cars = data_table(:cars)
    @cars.should_not be_nil
    @cars.sort.should_not be_nil
    @cars.sort.options.should have_at_least(2).things
    @cars.filter.should be_nil
  end
  
  it "should have optional filtering" do
    data_table(:cars) do |table|
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
    @cars.should_not be_nil
    @cars.filter.should_not be_nil
    @cars.filter.elements.should have_at_least(1).things
    @cars.sort.should be_nil
  end
  
  it "should provide options suitable for will_paginate integration"
  
  it "should handle options gracefully from everywhere, including the kitchen sink"
  
  # html options for form elements, url options for url generation, etc.
  
  describe "fully specced" do
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
      @opts = {:remote => {:url => '/cars/hottest_sellers', :update => 'hotBox'},
                            :with => [:tab] }
      @default_opts = {:id => "filterForm"}
    end
    
    it "should remove :with option for remote filter form submission" do
      @cars.options = @opts
      @cars.options_for_remote_function.should_not include(:with)
    end
    
    it "should be able to have sort and filter specifications" do
      @cars.should_not be_nil
      @cars.sort.should_not be_nil
      @cars.sort.options.should have_at_least(2).things
      @cars.filter.should_not be_nil
      @cars.filter.elements.should have_at_least(1).things
    end
    
    describe "with no additional parameters" do
            
      it "should be able to expose parameters that should be used by other libraries" do
        @cars.exposed_params.should == {}
      end
      
      it "should be able to store remote form submission parameters" do
        @cars.options = @opts
        @cars.options.should == @opts.merge(@default_opts)
      end

    end
    
    describe "when sorted" do
      before(:each) do
        @parms = {:cars => {:sort_key => "year", :sort_order => "asc"}}
        @sorted_cars = data_table(:cars).with(@parms)
      end
      
      it "should be able to expose parameters that should be used by other libraries" do
        @sorted_cars.exposed_params.should == @parms.flatten_one_level
      end

      
      it "should be able to store remote form submission parameters" do
        @sorted_cars.options = @opts
        @sorted_cars.options.should == @opts.merge(@default_opts)
      end
      
      it "should be able to merge sort parameters for form submission" do
        new_keys = {:color => "blue"}
        merged = @sorted_cars.merged_params(new_keys)
        merged.should == {"cars[color]"=>"blue", "cars[sort_key]" => "year", "cars[sort_order]" => "asc"}
      end
      
    end
    
    describe "when filtered" do
      before(:each) do
        @parms = {:cars => {:color => "blue"}}
        @filtered_cars = data_table(:cars).with(@parms)
      end
      
      it "should be able to expose parameters that should be used by other libraries" do
        @filtered_cars.exposed_params.should == @parms.flatten_one_level
      end

      
      it "should be able to store remote form submission parameters" do
        @filtered_cars.options = @opts
        @filtered_cars.options.should == @opts.merge(@default_opts)
      end
      
      it "should be able to merge sort parameters for form submission" do
        new_keys = {:sort_key => "make", :sort_order => "desc"}
        merged = @filtered_cars.merged_params(new_keys)
        merged.should == {"cars[color]"=>"blue", "cars[sort_key]" => "make", "cars[sort_order]" => "desc"}
      end
      
    end
    
    describe "when sorted and filtered" do
      before(:each) do
        @parms = {:cars => {:sort_key => "year", :sort_order => "asc", :color => "blue"}}
        @sorted_and_filtered_cars = data_table(:cars).with(@parms)
      end
      
      it "should be able to expose parameters that should be used by other libraries" do
        @sorted_and_filtered_cars.exposed_params.should == @parms.flatten_one_level
      end

      
      it "should be able to store remote form submission parameters" do
        @sorted_and_filtered_cars.options = @opts
        @sorted_and_filtered_cars.options.should == @opts.merge(@default_opts)
      end
      
      it "should be able to override sort parameters for form submission" do
        new_keys = {:sort_key => "make", :sort_order => "desc"}
        merged = @sorted_and_filtered_cars.merged_params(new_keys)
        merged.should == {"cars[color]"=>"blue", "cars[sort_key]" => "make", "cars[sort_order]" => "desc"}
      end
      
    end
    
  end
  
end