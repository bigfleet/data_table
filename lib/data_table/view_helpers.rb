%w[sort_view_helpers filter_view_helpers].each {|file| require "data_table/#{file}"}

module DataTable
  
  include SortViewHelpers
  include FilterViewHelpers
  # = Data Table view helpers
  #
  # These methods are made available in your view templates to render
  # the table.  
  module ViewHelpers
  end
end