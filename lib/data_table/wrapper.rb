module DataTable
  class Wrapper
    attr_accessor :sort, :filter, :params, :form_options
    
    def filter_spec(options={}, &block)
      @filter = Filter.spec(options, &block)
      @filter.wrapper = self
      @filter
    end
    
    def sort_spec(options={}, &block)
      @sort = Sort.spec(options, &block)
      @sort.wrapper = self
      @sort
    end
    
    def with(params)
      w = Wrapper.new
      w.sort = @sort.with(params)
      w.filter = @filter.with(params)
      w.params = params
      w
    end
    
    def exposed_params
      params.flatten_one_level
    end
    
    def conditions
      @filter.conditions
    end
    
    def options
      @filter.options
    end
    
    
  end
end