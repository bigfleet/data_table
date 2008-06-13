require File.dirname(__FILE__) + '/spec_helper'

describe DataTable::SortViewHelpers do
  
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
    @make_desc_params = {:cars => {:sort_key => "make", :sort_order => "desc"}}
    @make_asc_params = {:cars => {:sort_key => "make", :sort_order => "asc"}}
    @year_desc_params = {:cars => {:sort_key => "year", :sort_order => "desc"}}
    @year_asc_params = {:cars => {:sort_key => "year", :sort_order => "asc"}}    
  end
  
  describe "in partial rendering mode" do
    
    it "should be implemented"
    
  end
  
  describe "in ERB mode" do
    
    describe "with no additional parameters" do
      
      before(:each) do
        @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
        @controller.should_receive(:data_tables).with().and_return(@data_tables)
        @controller.should_receive(:url_for).with(@make_desc_params.flatten_one_level).and_return "Boobs."
        @controller.should_receive(:url_for).with(@year_desc_params.flatten_one_level).and_return "Boobs."        
        @sort_html = sort_header(:cars)
        @cars = @data_tables[:cars]
      end

      it "should render in AJAX mode" do
        @sort_html.should match(/Ajax.Updater/)
      end

      it "should internalize the form options correctly"

      describe "the default sort tag" do

        it "should reference its field name"

        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use the icon for the default sort"

      end

      describe "the secondary sort tag" do

        it "should reference its field name"
        
        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use an icon representing an unsorted condition"        

      end

    end
    
    describe "with parameters for sorting" do

      it "should render in AJAX mode"

      it "should internalize the form options correctly"

      describe "the default sort tag" do

        it "should reference its field name"

        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use the icon for the default sort"

      end

      describe "the secondary sort tag" do

        it "should reference its field name"
        
        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use an icon representing an unsorted condition"        

      end
      
    end
    
    describe "with parameters for filtering" do

      it "should render in AJAX mode"

      it "should internalize the form options correctly"

      describe "the default sort tag" do

        it "should reference its field name"

        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use the icon for the default sort"

      end

      describe "the secondary sort tag" do

        it "should reference its field name"
        
        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use an icon representing an unsorted condition"        

      end
    end
    
    describe "with parameters for sorting and filtering" do

      it "should render in AJAX mode"

      it "should internalize the form options correctly"

      describe "the default sort tag" do

        it "should reference its field name"

        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use the icon for the default sort"

      end

      describe "the secondary sort tag" do

        it "should reference its field name"
        
        it "shoud use AJAX submission"

        it "should have utilize any HTML options"
        
        it "should overwrite or ignore any pagination page"
        
        it "should use an icon representing an unsorted condition"        

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