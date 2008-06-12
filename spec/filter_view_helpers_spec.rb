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
    @cars = data_table(:cars)
    @opts = {:remote => {:url => '/cars/hottest_sellers', :update => 'hotBox'}, 
    :with => [:tab] }
    @controller = Object.new
  end
  
  describe "in partial rendering mode" do
    
    it "should be implemented"
    
  end
  
  describe "in XML builder mode" do
    
    describe "with no additional parameters" do

      it "should render in AJAX mode"

      it "should internalize the form options correctly"

      describe "the form tag" do

        it "should have one appearance"

        it "shoud use AJAX submission"

        it "should have a customizable DOM ID"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "the select tag" do

        it "should reference its field name"

        it "should have the right number of options"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "any extra parameters" do

        it "should not include a hidden field for sort key"

        it "should not include a hidden field for sort order"

        it "should not include a hidden field for tab"

      end

    end
    
    describe "with parameters for sorting" do

      it "should render in AJAX mode"

      it "should internalize the form options correctly"

      describe "the form tag" do

        it "should have one appearance"

        it "shoud use AJAX submission"

        it "should have a customizable DOM ID"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "the select tag" do

        it "should reference its field name"

        it "should have the right number of options"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "any extra parameters" do

        it "should not include a hidden field for sort key"

        it "should not include a hidden field for sort order"

        it "should not include a hidden field for tab"

      end

    end
    
    describe "with parameters for filtering" do

      it "should render in AJAX mode"

      it "should internalize the form options correctly"

      describe "the form tag" do

        it "should have one appearance"

        it "shoud use AJAX submission"

        it "should have a customizable DOM ID"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "the select tag" do

        it "should reference its field name"

        it "should have the right number of options"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "any extra parameters" do

        it "should not include a hidden field for sort key"

        it "should not include a hidden field for sort order"

        it "should not include a hidden field for tab"

      end

    end
    
    describe "with parameters for sorting and filtering" do

      it "should render in AJAX mode"

      it "should internalize the form options correctly"

      describe "the form tag" do

        it "should have one appearance"

        it "shoud use AJAX submission"

        it "should have a customizable DOM ID"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "the select tag" do

        it "should reference its field name"

        it "should have the right number of options"
        
        it "should be sensitive to a page parameter from will_paginate"

      end

      describe "any extra parameters" do

        it "should not include a hidden field for sort key"

        it "should not include a hidden field for sort order"

        it "should not include a hidden field for tab"

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