require File.dirname(__FILE__) + '/spec_helper'

describe DataTable::FilterViewHelpers do

  uses_data_table

  # Required Rails includes
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper  
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper

  attr_accessor :params


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
    @params = {}
    @cars = data_table(:cars)
    @opts = {:remote => {:url => '/cars/hottest_sellers', :update => 'hotBox'}, 
    :with => [:tab] }
    @data_tables = {}
    @controller = Object.new
  end
  
  describe "in partial rendering mode" do
    
    it "should be implemented"
    
  end
  
  describe "in XML builder mode" do
    
    describe "the form tag" do
      
      before(:each) do
        @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
        @controller.should_receive(:data_tables).with().and_return({:cars => @cars})
      end
      
      it "should have a customizable DOM ID" do
        # not married to the form of this hash
        @cars.options = @opts.merge(:html =>{:id => "car_color_filter"})
        @form_html = filter_for(:cars, @opts)
        @form_html.should match(/id=\"car_color_filter\"/)
      end

      
    end
    
    describe "with no additional parameters" do
      
      before(:each) do
        @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
        @controller.should_receive(:data_tables).with().and_return(@data_tables)
        @form_html = filter_for(:cars, @opts)
        @cars = @data_tables[:cars]
      end

      it "should internalize the form options correctly" do
        @cars.mode.should == :ajax
        @cars.remote_options.should == @opts[:remote]
      end

      describe "the form tag" do

        it "should render appropriately" do
          @form_html.should match(Regexp.compile("<form.*form>", Regexp::MULTILINE))
        end
        
        it "should not include the :with option in the Ajax:Updater" do
          @form_html.should_not match(/parameters:tab/)
        end

        it "shoud use AJAX submission" do
          @form_html.should match(/Ajax.Updater/)
        end

        
        it "should be sensitive to a page parameter from will_paginate" do
          @cars.merged_params({:page => 1}).should == {"cars[page]"=>"1"}
        end

      end

      describe "the select tag" do

        it "should reference its field name" do
          @form_html.should match(/"cars\[color\]"/)
        end
        
        it "should highlight the default filter selection" do
          @form_html.should match(/value=\"all\" selected=\"selected\"/)
        end

        it "should have the right number of options" do
          @form_html.split(/<option/).should have(7).things
          # 6 breaks, one for the prelude and the last one includes aftermath
        end
        
        it "should have a customizable DOM class" 

      end

      describe "any extra parameters" do

        it "should not include a hidden field for sort key" do
          @form_html.should_not match(/input\[type\]=\"hidden\"/)
        end

        it "should not include a hidden field for sort order" do
          @form_html.should_not match(/input\[type\]=\"hidden\"/)
        end

        it "should not include a hidden field for tab" do
          @form_html.should_not match(/input\[type\]=\"hidden\"/)
        end

      end

    end
    
    describe "with parameters for sorting" do
      
      before(:each) do
        @params = {:cars => {:sort_key => "year", :sort_order => "desc"}}
        @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
        @controller.should_receive(:data_tables).with().and_return(@data_tables)
        @form_html = filter_for(:cars, @opts)
        @cars = @data_tables[:cars]
      end

      it "should internalize the form options correctly" do
        @cars.mode.should == :ajax
        @cars.remote_options.should == @opts[:remote]
      end

      describe "the form tag" do
        
        it "should render appropriately" do
          @form_html.should match(Regexp.compile("<form.*form>", Regexp::MULTILINE))
        end
        
        it "should not include the :with option in the Ajax:Updater" do
          @form_html.should_not match(/parameters:tab/)
        end

        it "shoud use AJAX submission" do
          @form_html.should match(/Ajax.Updater/)
        end

      end

      describe "the select tag" do

        it "should reference its field name" do
          @form_html.should match(/name="cars\[color\]"/)
        end
        
        it "should highlight the default filter selection" do
          @form_html.should match(/value=\"all\" selected=\"selected\"/)
        end

        it "should have the right number of options" do
          @form_html.split(/<option/).should have(7).things
          # 6 breaks, one for the prelude and the last one includes aftermath
        end

      end

      describe "any extra parameters" do

        it "should include a hidden field for sort key" do
          @form_html.should match(
            regexify('<input id="cars_sort_key" name="cars[sort_key]" type="hidden" value="year" />', 
              Regexp::MULTILINE)
          )
        end

        it "should include a hidden field for sort order" do
          @form_html.should match(
            regexify('<input id="cars_sort_order" name="cars[sort_order]" type="hidden" value="desc" />', 
              Regexp::MULTILINE)
          )          
        end

        it "should not include a hidden field for tab" do
          @form_html.should_not match(/name="tab" type="hidden" value=.*/)
        end

      end

    end
    
    describe "with parameters for filtering" do
      
      before(:each) do
        @params = {:cars => {:color => "blue"}}
        @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
        @controller.should_receive(:data_tables).with().and_return(@data_tables)
        @form_html = filter_for(:cars, @opts)
        @cars = @data_tables[:cars]
        @cars.filter.active_elements.should_not be_empty
      end

      it "should internalize the form options correctly" do
        @cars.mode.should == :ajax
        @cars.remote_options.should == @opts[:remote]
      end


      describe "the form tag" do

        it "should render appropriately" do
          @form_html.should match(Regexp.compile("<form.*form>", Regexp::MULTILINE))
        end
        
        it "should not include the :with option in the Ajax:Updater" do
          @form_html.should_not match(/parameters:tab/)
        end

        it "shoud use AJAX submission" do
          @form_html.should match(/Ajax.Updater/)
        end

      end

      describe "the select tag" do

        it "should reference its field name" do
          @form_html.should match(/name="cars\[color\]"/)
        end
        
        it "should not highlight the default filter selection" do
          @form_html.should_not match(/value=\"all\" selected=\"selected\"/)
        end
        
        it "should highlight the selected filter option" do
          @form_html.should match(/value=\"blue\" selected=\"selected\"/)
        end

        it "should have the right number of options" do
          @form_html.split(/<option/).should have(7).things
          # 6 breaks, one for the prelude and the last one includes aftermath
        end

      end

      describe "any extra parameters" do

        it "should not include a hidden field for sort key" do
          @form_html.should_not match(/input\[type\]=\"hidden\"/)
        end

        it "should not include a hidden field for sort order" do
          @form_html.should_not match(/input\[type\]=\"hidden\"/)
        end

        it "should not include a hidden field for tab" do
          @form_html.should_not match(/input\[type\]=\"hidden\"/)
        end

      end

    end
    
    describe "with parameters for sorting and filtering, and external parameters" do
      
      before(:each) do
        @params = {:cars => {:sort_key => "year", :sort_order => "desc", :color => "blue"}, :tab => "used"}
        @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
        @controller.should_receive(:data_tables).with().and_return(@data_tables)
        @form_html = filter_for(:cars, @opts)
        @cars = @data_tables[:cars]
      end

      it "should internalize the form options correctly" do
        @cars.mode.should == :ajax
        @cars.remote_options.should == @opts[:remote]
      end


      describe "the form tag" do

        it "should render appropriately" do
          @form_html.should match(Regexp.compile("<form.*form>", Regexp::MULTILINE))
        end
        
        it "should not include the :with option in the Ajax:Updater" do
          @form_html.should_not match(/parameters:tab/)
        end

        it "shoud use AJAX submission" do
          @form_html.should match(/Ajax.Updater/)
        end
      end

      describe "the select tag" do

        it "should reference its field name" do
          @form_html.should match(/name="cars\[color\]"/)
        end
        
        it "should not highlight the default filter selection" do
          @form_html.should_not match(/value=\"all\" selected=\"selected\"/)
        end
        
        it "should highlight the selected filter option" do
          @form_html.should match(/value=\"blue\" selected=\"selected\"/)
        end

        it "should have the right number of options" do
          @form_html.split(/<option/).should have(7).things
          # 6 breaks, one for the prelude and the last one includes aftermath
        end

      end

      describe "any extra parameters" do

        it "should include a hidden field for sort key" do
          @form_html.should match(
            regexify('<input id="cars_sort_key" name="cars[sort_key]" type="hidden" value="year" />', 
              Regexp::MULTILINE)
          )
        end

        it "should include a hidden field for sort order" do
          @form_html.should match(
            regexify('<input id="cars_sort_order" name="cars[sort_order]" type="hidden" value="desc" />', 
              Regexp::MULTILINE)
          )          
        end

        it "should include a hidden field for tab" do
          @form_html.should match(
            regexify('<input id="cars_tab" name="tab" type="hidden" value="used" />', 
              Regexp::MULTILINE)
          )
        end

      end

    end
    
    describe "with parameters for sorting and filtering" do
      
      before(:each) do
        @params = {:cars => {:sort_key => "year", :sort_order => "desc", :color => "blue"}}
        @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
        @controller.should_receive(:data_tables).with().and_return(@data_tables)
        @form_html = filter_for(:cars, @opts)
        @cars = @data_tables[:cars]
      end

      it "should internalize the form options correctly" do
        @cars.mode.should == :ajax
        @cars.remote_options.should == @opts[:remote]
      end


      describe "the form tag" do

        it "should render appropriately" do
          @form_html.should match(Regexp.compile("<form.*form>", Regexp::MULTILINE))
        end
        
        it "should not include the :with option in the Ajax:Updater" do
          @form_html.should_not match(/parameters:tab/)
        end

        it "shoud use AJAX submission" do
          @form_html.should match(/Ajax.Updater/)
        end
      end

      describe "the select tag" do

        it "should reference its field name" do
          @form_html.should match(/name="cars\[color\]"/)
        end
        
        it "should not highlight the default filter selection" do
          @form_html.should_not match(/value=\"all\" selected=\"selected\"/)
        end
        
        it "should highlight the selected filter option" do
          @form_html.should match(/value=\"blue\" selected=\"selected\"/)
        end

        it "should have the right number of options" do
          @form_html.split(/<option/).should have(7).things
          # 6 breaks, one for the prelude and the last one includes aftermath
        end

      end

      describe "any extra parameters" do

        it "should include a hidden field for sort key" do
          @form_html.should match(
            regexify('<input id="cars_sort_key" name="cars[sort_key]" type="hidden" value="year" />', 
              Regexp::MULTILINE)
          )
        end

        it "should include a hidden field for sort order" do
          @form_html.should match(
            regexify('<input id="cars_sort_order" name="cars[sort_order]" type="hidden" value="desc" />', 
              Regexp::MULTILINE)
          )          
        end

        it "should not include a hidden field for tab" do
          @form_html.should_not match(/name="tab" type="hidden" value=.*/)
        end

      end

    end
    
    
  end

  protected

  # Just eliminating this from the Rails call-stack
  def protect_against_forgery?

  end

  def controller
    @controller
  end

end