require File.dirname(__FILE__) + '/spec_helper'

describe DataTable::PaginationSupport do
  
  uses_data_table
  
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
  end
  
  it "should setup correctly"
  
end