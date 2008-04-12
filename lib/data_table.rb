require 'active_support'
include ActiveSupport::CoreExtensions::String::Inflections 

# THIS DRIVES ME CRAZY
require 'data_table/filter_element'
require 'data_table/filter_selection'
require 'data_table/filter'

module DataTable

  module InstanceMethods
    
    def filter_spec(&block)
      filter = Filter.spec &block
      (@filters ||= {})[filter.name] = filter
    end
    
    def conditions_for(filter_name)
      raise @filters[filter_name]
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