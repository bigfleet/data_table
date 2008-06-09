require 'active_support'
gem 'actionpack', ">= 1.13.3"
require 'erb'
include ActiveSupport::CoreExtensions::String::Inflections 

%w[filter_element filter_selection filter sort sort_option].each {|file| require "data_table/#{file}"}

module DataTable

  module InstanceMethods
    
    
    # TODO: I definitely prefer the Filter.spec syntax
    def filter_spec(options, &block)
      filter = Filter.spec(options, &block)
      (@filters ||= {})[filter.name] = filter
    end
    
    # TODO: Take care that the sorting can be used without filtering
    def to_sort(filter, options = {}, &block)
      sort = Sort.spec(options, &block)
      filter.sort = sort
      sort.filter = filter
      sort
    end
    
    def conditions_for(filter_name)
      filter = find_filter(filter_name)
      filter.with(params).conditions
    end
    
    def options_for(filter_name)
      filter = find_filter(filter_name)
      filter.with(params).options
    end
    
    def find_filter(filter_name)
      @filters[filter_name]
    end
    
  end

  module ClassMethods
    def uses_data_table
      include DataTable::InstanceMethods
    end
  end
  
  
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end
  
  
end

ActionController::Base.send :include, DataTable
require 'data_table/view_helpers' unless ActionView::Base.instance_methods.include? 'filter_form'
ActionView::Base.class_eval { 
  include DataTable::ViewHelpers
  include DataTable::SortViewHelpers
  include DataTable::FilterViewHelpers
}