require File.dirname(__FILE__) + '/spec_helper'

describe "a data_table" do
  
  uses_data_table
    
  it "should define a data_table method" do
    self.should respond_to(:data_table)
  end
  
  it "should support basic sorting" do
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
  
  it "should support basic filtering" do
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
      @url_options = {:controller => "cars", :action => "hottest_sellers"}
      @remote_options = {:update => 'hotBox'}
      @other_options = {:with => [:tab]}
    end
    
    it "should have a default form ID" do
      @cars.form_id.should == "filterForm"
    end
    
    it "should have an overridable form ID" do
      form_id = "hottest_cars_filter"
      @cars.html_options = {:filter => {:id => form_id }}
      @cars.form_id.should == form_id
    end
    
    it "should be able to have sort and filter specifications" do
      @cars.should_not be_nil
      @cars.sort.should_not be_nil
      @cars.sort.options.should have_at_least(2).things
      @cars.filter.should_not be_nil
      @cars.filter.elements.should have_at_least(1).things
    end
    
    describe "when determining which parameters should be used for url generation" do
      
      it "should have no internal preconceptions about the url to submit" do
        @cars.params_for_url.should == {}
      end
      
      describe "when given basic url parameters" do
        
        before(:each) do
          @cars.url_options = @url_options
        end
        
        it "should be able to receive instruction about what url to submit to" do
          @cars.params_for_url.should == @url_options
        end
        
        describe "in sorting context" do
          before(:each) do
            @params = {:cars => {:sort_key => "make", :sort_order => "desc"}}
            @cars.params = @params
            @expected = @params.flatten_one_level.merge(@url_options)
            @expected_paginated = @expected.merge("cars[page]" => 2)
          end
          
          it "should be able to include sorting parameters" do
            @cars.params_for_url.should == @expected
          end

          it "should be able to include sorting parameters and pagination" do
            @cars.params_for_url(:page => 2).should == @expected_paginated
          end
          
        end
                
        it "should be able to include filtering parameters"
        
        it "should be able to include sorting and filtering parameters together"
        
        it "should be able to include pagination parameters"
        
      end
      
    end
    
    describe "when integrating with parameters" do
      
      # having no sorting or filtering will crash with nil reference
      
      it "should have optional sorting"
      
      it "should have optional filtering"
      
    end
    
    describe "with no additional parameters" do
            
      it "should be able to expose parameters that should be used by other libraries" do
        @cars.exposed_params.should == {}
      end
      
      it "should be able to store remote form submission parameters" do
        @cars.options = @opts
        @cars.options.should == @default_opts.merge(@opts)
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
        @sorted_cars.options.should == @default_opts.merge(@opts)
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
        @filtered_cars.options.should == @default_opts.merge(@opts)
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
        @sorted_and_filtered_cars.options.should == @default_opts.merge(@opts)
      end
      
      it "should be able to override sort parameters for form submission" do
        new_keys = {:sort_key => "make", :sort_order => "desc"}
        merged = @sorted_and_filtered_cars.merged_params(new_keys)
        merged.should == {"cars[color]"=>"blue", "cars[sort_key]" => "make", "cars[sort_order]" => "desc"}
      end
      
    end
    
  end
  
end