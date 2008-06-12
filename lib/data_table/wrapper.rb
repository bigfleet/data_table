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