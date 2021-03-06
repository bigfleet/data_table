# Stolen outright from will_paginate
require 'active_support'
require 'action_controller'
plugin_root = File.join(File.dirname(__FILE__), '..')

$:.unshift "#{plugin_root}/lib"

%w[filter_element filter_selection filter 
   sort sort_option wrapper pagination_support].each {|file| require "data_table/#{file}"}

class Hash
  def flatten_one_level
    return self if keys.empty?
    nest_key = keys.first
    nested = values.first
    result_hash = {}
    nested.map{ |o| result_hash[nest_key.to_s+'['+o.first.to_s+"]"] = o.last.to_s }
    result_hash
  end
end

module DataTable

  module InstanceMethods    
    
    def data_table(name, &block)
      if block
        yield(data_table_lookup[name] ||= Wrapper.new(:name => name))
      else
        find_data_table_by_name(name)
      end
    end
    
    def options_group_from(collection, options)
      collection.find(options).collect{ |ar|
        yield(ar)
      }
    end
    
    def params_for(name)
      find_data_table_by_name(name).with(params).params
    end
    
    def conditions_for(name)
      find_data_table_by_name(name).with(params).conditions
    end
    
    def options_for(name)
      table = find_data_table_by_name(name).with(params)
      f_and_s = table.filter_options.merge(table.sort_options)
      f_and_s.merge(:page => table.page)
    end
    
    def find_data_table_by_name(name)
      data_table_lookup[name]
    end
    
    def data_table_lookup
      @data_tables ||= {}
    end
    
    def data_tables
      @data_tables
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
require 'data_table/view_helpers'
ActionView::Base.class_eval { 
  include DataTable::ViewHelpers
  include DataTable::SortViewHelpers
  include DataTable::FilterViewHelpers
  include DataTable::PaginationSupport
}