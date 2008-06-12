module DataTable
  class Wrapper
    attr_accessor :name, :sort, :filter, :params, :form_options
    
    def initialize(options)
      @name = options[:name]
    end
    
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
      w = Wrapper.new(:name => @name)
      w.sort = @sort.with(params)
      w.sort.wrapper = self
      w.filter = @filter.with(params)
      w.filter.wrapper = self
      w.params = params
      w
    end
    
    # this returns a list of parameters suitable for passing to any Rails
    # helper containing all the parameters bound to this data_table, 
    # including any parameters that you pass in to this method.
    #
    # this call assumes that the parameters that you pass in are properly
    # (and flatly) scoped (e.g. :key => "value", not name[:key] => "value")
    # and not {:name => {:key => "value"}}
    def merged_params(other_hash)
      return {} unless params && params[@name]
      named_params = params[@name]
      {@name => (named_params.merge(other_hash))}.flatten_one_level
    end
    
    def exposed_params
      (params||{}).flatten_one_level
    end
    
    def conditions
      @filter.conditions
    end
    
    def options
      @filter.options
    end
    
    def all_options
      exposed_params.merge((form_options||{}))
    end
    
    def mode
      form_options && form_options[:form] ? :standard : :ajax
    end
    
    
  end
end