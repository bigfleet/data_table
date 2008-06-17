module DataTable
  module PaginationSupport
    
    def pagination_for(collection, table_name, options)
      will_paginate( collection, 
        options.reverse_merge(
          :renderer => "DataTable::LinkRenderer", 
          :data_table => controller.find_data_table_by_name(table_name))
      )
    end
    
    
    
  end
end