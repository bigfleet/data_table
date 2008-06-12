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
    @controller = Object.new
  end
  
  describe "in partial rendering mode" do
    
    it "should be implemented"
    
  end
  
  describe "in ERB mode" do
    
    describe "with no additional parameters" do

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