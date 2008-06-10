require File.dirname(__FILE__) + '/spec_helper'

describe DataTable::ViewHelpers do
  
  uses_data_table
  
  # Required Rails includes
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper
  
  attr_accessor :params
  
  before(:each) do
    @car_filter = filter_spec(:name => :cars) do |f|
      to_sort(f) do |s|
        s.default 'make'
        s.option  'year', 'desc'
      end
      f.element(:color) do |e|
        e.default "All"
        e.option  "Blue"
        e.option  "Red"
        e.option  "Silver"
        e.option  "Black"
        e.option  "Other"
      end
    end
    @controller = Object.new
    @controller.should_receive(:find_filter).with(:cars).and_return(@car_filter)
    @params_for_make_desc = {:cars => {:sort_key => "make", :sort_order => "desc"}}.flatten_one_level
    @url_for_make_desc = "?cars[sort_key]=make&cars[sort_order]=desc"
    @params_for_year_desc = {:cars => {:sort_key => "year", :sort_order => "desc"}}.flatten_one_level
    @url_for_year_desc = "?cars[sort_key]=year&cars[sort_order]=desc"
    @params_for_make_asc =  {:cars => {:sort_key => "make", :sort_order => "asc"}}.flatten_one_level
    @url_for_make_asc = "?cars[sort_key]=make&cars[sort_order]=asc"
    @params_for_year_asc =  {:cars => {:sort_key => "year", :sort_order => "asc"}}.flatten_one_level
    @url_for_year_asc = "?cars[sort_key]=year&cars[sort_order]=asc"
  end
  
  it "should be skinnable"

  describe "with no request parameters" do
    
    before(:each) do
      @params = {}
    end
    
    describe "regarding form submission" do
      
      it "should use AJAX-style submission by default" do
        filter_form(:cars).should match(/Ajax.Request/)
      end
            
      it "should allow inclusion of non-filter parameters into filtering" do
        @params = {:tab => "used"}
        @form_html = filter_form(:cars, :with => [:tab])
        @form_html.should match(/Ajax.Request/)
        @form_html.should match(/value=\"used\"/)
        @form_html.should_not match(Regexp.compile(Regexp.escape('input type="submit"')))
      end
      
      it "should allow AJAX-style submission to a distinct URL" do
        @form_html = filter_form(:cars, :remote => { :url => "/blah_url"})
        @form_html.should match(/Ajax.Request/)
        @form_html.should_not match(Regexp.compile(Regexp.escape('input type="submit"')))
        @form_html.should match(/\/blah_url/)
      end
      
    end
    
    
    describe "the filter form" do
    
      it "should not error when rendering the filter form" do
        filter_form(:cars).should_not be_nil
      end

      it "should render a default option as selected" do
        filter_form(:cars).should match(/<option value=\"all\" selected/)
      end
                
    end
    
    describe "the sort header" do
      
      before(:each) do
        @controller.should_receive(:url_for).with(@params_for_make_desc).and_return(@url_for_make_desc)
        @controller.should_receive(:url_for).with(@params_for_year_desc).and_return(@url_for_year_desc)
      end

      it "should render a sort header" do
        sort_header(:cars).should_not be_nil
      end

      it "should indicate that make is currently sorted in ascending order" do
        sort_header(:cars).should =~ /<img alt=\"Sort by Make\" border=\"0\" src=\"(.+)sort_asc.gif/
      end

      it "should have a click on make sort in descending order" do
        sort_header(:cars).should =~ Regexp.compile(Regexp.escape(@url_for_make_desc))
      end

      it "should have the first request to sort by year be in descending order" do
        sort_header(:cars).should =~ Regexp.compile(Regexp.escape(@url_for_year_desc))
      end
      
    end
    
    describe "using a key-by-key approach" do
      before(:each) do
        @sort = @controller.find_filter(:cars).sort
        @controller.should_receive(:url_for).with(@params_for_make_desc).and_return(@url_for_make_desc)
        @make_html = key_for(@sort, "make", {:caption => "Make of Automobile"})
      end
    
      it "should allow overriding of the default caption" do
        @make_html.should =~ /Make of Automobile/
      end
    
    end
    
  end
  
  describe "with request parameters for filtering" do
    
    before(:each) do
      @params = {:cars => {:color => "blue"}}
      @params_for_make_desc = {:cars => {:sort_key => "make", :sort_order => "desc", :color => "blue"}}.flatten_one_level
      @url_for_make_desc = "?cars[sort_key]=make&cars[sort_order]=desc&cars[color]=blue"
      @params_for_year_desc = {:cars => {:sort_key => "year", :sort_order => "desc", :color => "blue"}}.flatten_one_level
      @url_for_year_desc = "?cars[sort_key]=year&cars[sort_order]=desc&cars[color]=blue"      
    end
    
    describe "the filter form" do
    
      it "should not error when rendering the filter form" do
        filter_form(:cars).should_not be_nil
      end

      it "should not render a default option as selected" do
        filter_form(:cars).should_not match(/<option value=\"all\" selected/)
      end
    
      it "should render the selected parameter as selected" do
        filter_form(:cars).should match(/<option value=\"blue\" selected/)
      end
      
    end
    
    describe "the sort header" do
      
      before(:each) do
        @controller.should_receive(:url_for).with(@params_for_make_desc).and_return(@url_for_make_desc)
        @controller.should_receive(:url_for).with(@params_for_year_desc).and_return(@url_for_year_desc)
      end


      it "should render a sort header" do
        sort_header(:cars).should_not be_nil
      end
    end

    describe "for the make sort option" do
      before(:each) do
        @controller.should_receive(:url_for).with(@params_for_make_desc).and_return(@url_for_make_desc)        
        @sort = sort_header_for(:cars) do |sort|
          @make_html = key_for(sort, "make", {})
        end
      end

      it "should indicate that make is currently sorted in descending order" do
        @make_html.should =~ /<img alt=\"Sort by Make\" border=\"0\" src=\"(.+)sort_asc.gif/
      end

      it "should have a click on make sort in descending order" do
        @make_html.should have_html_link_with(
         {:cars => {:sort_key => "make", :sort_order => "desc", :color => "blue"}}.flatten_one_level
        )
      end

    end

    describe "for the year sort option" do

      before(:each) do
        @controller.should_receive(:url_for).with(@params_for_year_desc).and_return(@url_for_year_desc)
        @sort = sort_header_for(:cars) do |sort|
          @year_html = key_for(sort, "year", {})
        end
      end

      it "should have the first request to sort by year be in descending order" do
        @year_html.should have_html_link_with(
          {:cars => {:sort_key => "year", :sort_order => "desc", :color => "blue"}}.flatten_one_level
        )
      end

    end
    
  end
  
  describe "with request parameters for sorting" do
    
    before(:each) do
      @params = {:cars => {:sort_key => "make", :sort_order => "desc"}}
    end
    
    describe "the filter form" do
      
      it "should not error when rendering the filter form" do
        filter_form(:cars).should_not be_nil
      end

      it "should not error when rendering the filter form" do
        filter_form(:cars).should_not be_nil
      end

      it "should render a default option as selected" do
        filter_form(:cars).should match(/<option value=\"all\" selected/)
      end
      
      
    end
    
    describe "the sort header" do
      
      before(:each) do
        @controller.should_receive(:url_for).with(@params_for_make_asc).and_return(@url_for_make_asc)
        @controller.should_receive(:url_for).with(@params_for_year_desc).and_return(@url_for_year_desc)
      end
      
      it "should render a sort header" do
        sort_header(:cars).should_not be_nil
      end

      it "should indicate that make is currently sorted in descending order" do
        sort_header(:cars).should =~ /<img alt=\"Sort by Make\" border=\"0\" src=\"(.+)sort_desc.gif/
      end

      it "should have a click on make sort in ascending order" do
        sort_header(:cars).should =~ Regexp.compile(Regexp.escape(@url_for_make_asc))
      end

      it "should have the first request to sort by year be in descending order" do
        sort_header(:cars).should =~ Regexp.compile(Regexp.escape(@url_for_year_desc))
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