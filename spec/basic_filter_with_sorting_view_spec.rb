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
  end
  
  it "should find the filter storable and retrievable" do
    find_filter(:cars).should_not be_nil
    find_filter(:cars).should == @car_filter
  end
  
  it "should be skinnable"

  describe "with no request parameters" do
    
    before(:each) do
      @params = {}
    end
    
    it "should not error when rendering the filter form" do
      filter_form(:cars).should_not be_nil
    end

    it "should render a default option as selected" do
      filter_form(:cars).should match(/<option value=\"all\" selected/)
    end

    it "should render a sort header" do
      sort_header(:cars).should_not be_nil
    end

    it "should indicate that make is currently sorted in ascending order" do
      sort_header(:cars).should =~ /<img alt=\"Sort by Make\" border=\"0\" src=\"(.+)sort_asc.gif/
    end

    it "should have a click on make sort in descending order" do
      sort_header(:cars).should =~ /\?sort_key=make&sort_order=desc/
    end

    it "should have the first request to sort by year be in descending order" do
      sort_header(:cars).should =~ /\?sort_key=year&sort_order=desc/
    end
    
    describe "using a key-by-key approach" do
      before(:each) do
        @sort = @car_filter.sort
        @sort_option = @sort.option_with_name("make")
      end
      
      it "should expose a utilizable key" do
        @sort.should_not be_nil
        @sort_option.should_not be_nil
        @sort_option.key.should == "make"
      end
      
      it "should allow overriding of the default caption" do
        results = key(@sort, "make", {:caption => "Make of Automobile"})
        results.should =~ /Make of Automobile/
      end
      
    end
    
  end
  
  describe "with request parameters for filtering" do
    
    before(:each) do
      @params = {:cars => {:color => "blue"}}
    end
    
    it "should not error when rendering the filter form" do
      filter_form(:cars).should_not be_nil
    end

    it "should not render a default option as selected" do
      filter_form(:cars).should_not match(/<option value=\"all\" selected/)
    end
    
    it "should render the selected parameter as selected" do
      filter_form(:cars).should match(/<option value=\"blue\" selected/)
    end

    it "should render a sort header" do
      sort_header(:cars).should_not be_nil
    end
    
    describe "for the make sort option" do
      before(:each) do
        @sort = @car_filter.sort
        @make_html = key(@sort, "make", {})
      end
      
      it "should indicate that make is currently sorted in ascending order" do
        @make_html.should =~ /<img alt=\"Sort by Make\" border=\"0\" src=\"(.+)sort_asc.gif/
      end

      it "should have a click on make sort in descending order" do
        @make_html.should =~ /\?sort_key=make&sort_order=desc/
      end
      
    end
    
    describe "for the year sort option" do
      
      before(:each) do
        @sort = @car_filter.sort
        @year_html = key(@sort, "year", {})
      end

      it "should have the first request to sort by year be in descending order" do
        @year_html.should =~ /\?sort_key=year&sort_order=desc/
      end
      
    end
    
  end
  
  describe "with request parameters for sorting" do
    
    before(:each) do
      @params = {:cars => {:sort_key => "make", :sort_order => "desc"}}
    end
    
    it "should not error when rendering the filter form" do
      filter_form(:cars).should_not be_nil
    end

    it "should not error when rendering the filter form" do
      filter_form(:cars).should_not be_nil
    end

    it "should render a default option as selected" do
      filter_form(:cars).should match(/<option value=\"all\" selected/)
    end
    
    it "should render a sort header" do
      sort_header(:cars).should_not be_nil
    end

    it "should indicate that make is currently sorted in descending order" do
      sort_header(:cars).should =~ /<img alt=\"Sort by Make\" border=\"0\" src=\"(.+)sort_desc.gif/
    end

    it "should have a click on make sort in descending order" do
      sort_header(:cars).should =~ /\?sort_key=make&sort_order=asc/
    end

    it "should have the first request to sort by year be in descending order" do
      sort_header(:cars).should =~ /\?sort_key=year&sort_order=desc/
    end
    
  end
  
  protected
  
  # Just eliminating this from the Rails call-stack
  def protect_against_forgery?
    
  end
  
  # This is way too tricky-- made to get these tests and needed 
  # Rails plugin structure living and working together
  def controller
    self
  end
  
end