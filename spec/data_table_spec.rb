require File.dirname(__FILE__) + '/spec_helper'

describe "a data_table" do
  
  uses_data_table
    
  it "should define a data_table method" do
    self.should respond_to(:data_table)
  end
  
  describe "while supporting basic sorting" do
    
    before(:each) do
      data_table(:cars) do |table|
        table.sort_spec do |s|
          s.default 'make'
          s.option  'year', 'desc'
        end
      end
      @cars = data_table(:cars)
    end
    
    it "should be accessible via the data_table call" do
      @cars.should_not be_nil
    end
    
    it "should have a reference to a sort object" do
      @cars.sort.should_not be_nil
    end
    
    it "should properly initialize sort options" do
      @cars.sort.options.should have(2).things
    end
    
    it "should have no filter pointer" do
      @cars.filter.should be_nil
    end
    
    it "should note raise an error when internalizing request params" do
      # these are a "raise no error" type of test-- results are later
      sort_params = {:cars => {:sort_order => "desc", :sort_key => "make"}}
      # FIXME: be_is_a? [jvf]
      @cars.with(sort_params).should be_is_a(DataTable)
    end
    
  end
  
  describe "while supporting basic filtering" do
    
    before(:each) do
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
    end
    
    it "should be accessible via the data_table call" do
      @cars.should_not be_nil
    end
    
    it "should have a reference to a filter object" do
      @cars.filter.should_not be_nil
    end
    
    it "should properly initialize filter elements" do
      @cars.filter.elements.should have(1).things
    end
    
    it "should have no sort pointer" do
      @cars.sort.should be_nil
    end
    
    it "should note raise an error when internalizing request params" do
      sort_params = {:cars => {:color => "blue"}}
      # FIXME: be_is_a? [jvf]
      @cars.with(sort_params).should be_is_a(DataTable)
    end
    
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
            @expected_paginated = @expected.merge("cars[page]" => "2")
          end
          
          it "should be able to include sorting parameters" do
            @cars.params_for_url.should == @expected
          end

          it "should be able to include sorting parameters and pagination" do
            @cars.params_for_url(:page => 2).should == @expected_paginated
          end
          
        end
        
        describe "in filtering context" do
          
          before(:each) do
            @params = {:cars => {:color => "blue"}}
            @cars.params = @params
            @expected = @params.flatten_one_level.merge(@url_options)
            @expected_paginated = @expected.merge("cars[page]" => "2")
          end
          
          it "should be able to include sorting parameters" do
            @cars.params_for_url.should == @expected
          end

          it "should be able to include sorting parameters and pagination" do
            @cars.params_for_url(:page => 2).should == @expected_paginated
          end
          
        end
        
        describe "in sorting and filtering context" do
          
          before(:each) do
            @params = {:cars => {:color => "blue", :sort_key => "make", :sort_order => "desc"}}
            @cars.params = @params
            @expected = @params.flatten_one_level.merge(@url_options)
            @expected_paginated = @expected.merge("cars[page]" => "2")
          end
          
          it "should be able to include sorting parameters" do
            @cars.params_for_url.should == @expected
          end

          it "should be able to include sorting parameters and pagination" do
            @cars.params_for_url(:page => 2).should == @expected_paginated
          end
          
        end
        
      end
      
    end
        
    describe "when sorted" do
      before(:each) do
        @parms = {:cars => {:sort_key => "year", :sort_order => "asc"}}
        @sorted_cars = data_table(:cars).with(@parms)
        @sorted_cars.remote_options = @remote_options
      end
      
      it "should be able to store remote form submission parameters" do
        @sorted_cars.remote_options = @remote_options
      end
      
      it "should be able to merge remote form submission parameters" do
        url = "/cars/hottest_sellers"
        opts = @sorted_cars.remote_options_with_url(url)
        opts.should == @remote_options.merge(:url => url)
      end
      
      it "should be able to remove nesting for ease of use" do
        @sorted_cars.nested_params.should == @parms[:cars]
      end
      
      it "should have an active sort option" do
        @sorted_cars.sort.selected.should_not be_nil
      end
    end
    
    describe "when filtered" do
      before(:each) do
        @parms = {:cars => {:color => "blue"}}
        @filtered_cars = data_table(:cars).with(@parms)
        @filtered_cars.remote_options = @remote_options
      end
      
      it "should be able to store remote form submission parameters" do
        @filtered_cars.remote_options = @remote_options
      end
      
      it "should be able to merge remote form submission parameters" do
        url = "/cars/hottest_sellers"
        opts = @filtered_cars.remote_options_with_url(url)
        opts.should == @remote_options.merge(:url => url)
      end
      
      it "should be able to remove nesting for ease of use" do
        @filtered_cars.nested_params.should == @parms[:cars]
      end
      
      it "should have an active filter option" do
        @filtered_cars.filter.active_elements.should have_at_least(1).thing
      end
    end
    
    describe "when sorted and filtered" do
      before(:each) do
        @parms = {:cars => {:sort_key => "year", :sort_order => "asc", :color => "blue"}}
        @sorted_and_filtered_cars = data_table(:cars).with(@parms)
        @sorted_and_filtered_cars.remote_options = @remote_options
      end
      
      it "should be able to store remote form submission parameters" do
        @sorted_and_filtered_cars.remote_options = @remote_options
      end
      
      it "should be able to merge remote form submission parameters" do
        url = "/cars/hottest_sellers"
        opts = @sorted_and_filtered_cars.remote_options_with_url(url)
        opts.should == @remote_options.merge(:url => url)
      end
      
      it "should be able to remove nesting for ease of use" do
        @sorted_and_filtered_cars.nested_params.should == @parms[:cars]
      end
      
      it "should have an active filter option" do
        @sorted_and_filtered_cars.filter.active_elements.should have_at_least(1).thing
      end
      
      it "should have an active sort option" do
        @sorted_and_filtered_cars.sort.selected.should_not be_nil
      end

    end
    
  end
  
end