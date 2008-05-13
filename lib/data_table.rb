require 'active_support'
include ActiveSupport::CoreExtensions::String::Inflections 

# THIS DRIVES ME CRAZY
require 'data_table/filter_element'
require 'data_table/filter_selection'
require 'data_table/filter'

module DataTable

  module InstanceMethods
    
    
    # TODO: I definitely prefer the Filter.spec syntax
    def filter_spec(options, &block)
      filter = Filter.spec(options, &block)
      (@filters ||= {})[filter.name] = filter
      #raise @filters.inspect
    end
    
    def conditions_for(filter_name)
      filter = @filters[filter_name]
      filter.conditions(@params)
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