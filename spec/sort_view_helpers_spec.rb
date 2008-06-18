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
    @cars = data_table(:cars)
    @params = {}
    @opts = {:remote => {:url => '/cars/hottest_sellers', :update => 'hotBox', :method => "get"}, 
    :with => [:tab] }
    @data_tables = {}
    @controller = Object.new
    @make_desc_params = {:cars => {:sort_key => "make", :sort_order => "desc"}}
    @make_desc_url = "?cars%5Bsort_key%5D=make&amp;cars%5Bsort_order%5D=desc"
    @make_asc_params = {:cars => {:sort_key => "make", :sort_order => "asc"}}
    @make_asc_url = "?cars%5Bsort_key%5D=make&amp;cars%5Bsort_order%5D=asc"    
    @year_desc_params = {:cars => {:sort_key => "year", :sort_order => "desc"}}
    @year_desc_url = "?cars%5Bsort_key%5D=year&amp;cars%5Bsort_order%5D=desc"    
    @year_asc_params = {:cars => {:sort_key => "year", :sort_order => "asc"}}
    @year_asc_url = "?cars%5Bsort_key%5D=year&amp;cars%5Bsort_order%5D=asc"    
    @controller.should_receive(:find_data_table_by_name).with(:cars).and_return(@cars)
    @controller.should_receive(:data_tables).with().and_return(@data_tables)
    @controller.should_receive(:protect_against_forgery?).at_least(1).and_return(false)
  end
  
  describe "in partial rendering mode" do
    
    it "should be implemented"
    
  end
  
  describe "in ERB mode" do
    
    describe "with no additional parameters" do
      
      before(:each) do
        @controller.should_receive(:url_for).with(@make_desc_params.flatten_one_level).at_least(1).and_return(@make_desc_url)
        @controller.should_receive(:url_for).with(@year_desc_params.flatten_one_level).at_least(1).and_return(@year_desc_url)
        @html_helper = sort_header(:cars, @opts) do |sort|
          @make_html = sort.column :make, :caption => "Manufacturer"
          @year_html = sort.column :year
        end
        @cars = @data_tables[:cars]
      end

      it "should render in AJAX mode" do
        @html_helper.mode.should == :ajax
      end

      describe "the default sort tag" do

        it "shoud use AJAX submission" do
          @make_html.should match(/Ajax.Updater/)
        end

        it "should utilize any HTML options" do
          @make_html.should match(/Manufacturer/)
        end
        
        it "should overwrite or ignore any pagination page" do
          pending "this should be moved outside this descriptor block"
        end
        
        it "should use the icon for the default sort" do
          @make_html.should match(/sort_asc.gif/)
        end

      end

      describe "the secondary sort tag" do

        it "shoud use AJAX submission" do
          @year_html.should match(/Ajax.Updater/)
        end

        it "should have a reasonable default caption" do
          @year_html.should match(/Year/)
        end
        
        it "should overwrite or ignore any pagination page" do
          pending "this should be moved outside this descriptor block"
        end
        
        it "should use the icon for the default sort" do
          @year_html.should match(/sortArrow001.gif/)
        end
        
        it "should respect the preferred initial sort order" do
          # based on the implementation, this test is sort of redundant;
          # we had the mock return this.  
          @year_html.should match(/cars%5Bsort_key%5D=year&amp;cars%5Bsort_order%5D=desc/)
        end

      end

    end
    
    describe "with parameters for sorting" do
      
      before(:each) do
        @params = {:cars => {:sort_key => "year", :sort_order => "desc"}}
        @controller.should_receive(:url_for).with(@make_asc_params.flatten_one_level).at_least(1).and_return(@make_asc_url)
        @controller.should_receive(:url_for).with(@year_asc_params.flatten_one_level).at_least(1).and_return(@year_asc_url)

        @html_helper = sort_header(:cars, @opts) do |sort|
          @make_html = sort.column :make, :caption => "Manufacturer"
          @year_html = sort.column :year
        end
        @cars = @data_tables[:cars]
      end

      it "should render in AJAX mode" do
        @html_helper.mode.should == :ajax
      end

      describe "the default sort tag" do

        it "shoud use AJAX submission" do
          @make_html.should match(/Ajax.Updater/)
        end

        it "should have utilize any HTML options" do
          @make_html.should match(/Manufacturer/)
        end
        
        it "should use the unsorted icon" do
          @make_html.should match(/sortArrow001.gif/)
        end

      end

      describe "the secondary sort tag" do
        
        it "should use AJAX submission" do
          @year_html.should match(/Ajax.Updater/)
        end

        it "should use a sensible default for column caption" do
          @year_html.should match(/Year/)
        end
        
        it "should indicate descending order has been selected" do
          @year_html.should match(/sort_desc.gif/)
        end
        
        it "should link to the alternative sort ordering" do
          @year_html.should match(/cars%5Bsort_key%5D=year&amp;cars%5Bsort_order%5D=asc/)
        end

      end
      
    end
    
    describe "with parameters for filtering" do
      
      before(:each) do
        @params = {:cars => {:color => "blue"}}
        make_params = {:cars => {:color => "blue", :sort_key => "make", :sort_order => "desc"}}
        year_params = {:cars => {:color => "blue", :sort_key => "year", :sort_order => "desc"}}
        filtered_make_url = @make_desc_url + "&amp;cars%5Bcolor%5D=blue"
        filtered_year_url = @year_desc_url + "&amp;cars%5Bcolor%5D=blue"        
        @controller.should_receive(:url_for).with(make_params.flatten_one_level).at_least(1).and_return(filtered_make_url)
        @controller.should_receive(:url_for).with(year_params.flatten_one_level).at_least(1).and_return(filtered_year_url)

        @html_helper = sort_header(:cars, @opts) do |sort|
          @make_html = sort.column :make, :caption => "Manufacturer"
          @year_html = sort.column :year
        end
        @cars = @data_tables[:cars]
      end

      it "should render in AJAX mode" do
        @html_helper.mode.should == :ajax
      end

      describe "the default sort tag" do

        it "shoud use AJAX submission" do
          @make_html.should match(/Ajax.Updater/)
        end

        it "should utilize any HTML options" do
          @make_html.should match(/Manufacturer/)
        end
        
        it "should use the icon for the default sort" do
          @make_html.should match(/sort_asc.gif/)
        end

      end

      describe "the secondary sort tag" do

        it "shoud use AJAX submission" do
          @year_html.should match(/Ajax.Updater/)
        end

        it "should have a reasonable default caption" do
          @year_html.should match(/Year/)
        end
        
        it "should use the icon for the default sort" do
          @year_html.should match(/sortArrow001.gif/)
        end
        
        it "should respect the preferred initial sort order" do
          # based on the implementation, this test is sort of redundant;
          # we had the mock return this.  
          @year_html.should match(/cars%5Bsort_key%5D=year&amp;cars%5Bsort_order%5D=desc&amp;cars%5Bcolor%5D=blue/)
        end

      end
    end
    
    describe "with parameters for sorting and filtering" do
      
      before(:each) do
        @params = {:cars => {:color => "blue", :sort_key => "year", :sort_order => "desc"}}
        make_params = {:cars => {:color => "blue", :sort_key => "make", :sort_order => "asc"}}
        year_params = {:cars => {:color => "blue", :sort_key => "year", :sort_order => "asc"}}
        filtered_make_url = @make_desc_url + "&amp;cars%5Bcolor%5D=blue"
        filtered_year_url = @year_asc_url + "&amp;cars%5Bcolor%5D=blue"        
        @controller.should_receive(:url_for).with(make_params.flatten_one_level).at_least(1).and_return(filtered_make_url)
        @controller.should_receive(:url_for).with(year_params.flatten_one_level).at_least(1).and_return(filtered_year_url)

        @html_helper = sort_header(:cars, @opts) do |sort|
          @make_html = sort.column :make, :caption => "Manufacturer"
          @year_html = sort.column :year
        end
        @cars = @data_tables[:cars]
      end

      it "should render in AJAX mode" do
        @html_helper.mode.should == :ajax
      end

      describe "the default sort tag" do

        it "shoud use AJAX submission" do
          @make_html.should match(/Ajax.Updater/)
        end

        it "should have utilize any HTML options" do
          @make_html.should match(/Manufacturer/)
        end
        
        it "should use the unsorted icon" do
          @make_html.should match(/sortArrow001.gif/)
        end

      end

      describe "the secondary sort tag" do
        
        it "should use AJAX submission" do
          @year_html.should match(/Ajax.Updater/)
        end

        it "should use a sensible default for column caption" do
          @year_html.should match(/Year/)
        end
        
        it "should indicate descending order has been selected" do
          @year_html.should match(/sort_desc.gif/)
        end
        
        it "should link to the alternative sort ordering" do
          @year_html.should match(/cars%5Bsort_key%5D=year&amp;cars%5Bsort_order%5D=asc&amp;cars%5Bcolor%5D=blue/)
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