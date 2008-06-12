module DataTable
  
  # Guidelines:
  # params are hashes that are involved directly with query parameters
  # attached to the request/response cycle.  If it could end up on an AR
  # object, or is related to something that is, you are looking for one
  # or another of the params objects
  #
  # options are hashes that are involved with either the construction of
  # URL's, callbacks, CSS classes, Ajax, JavaScript activation, moon phase,
  # etc.  If you are trying to set which URL to hit or jimmy with the way
  # that your page works
  # 
  # Of course, to make this interesting, there is one exception.  The :with
  # option allows the client code to define a set of parameters that will
  # be included in any of data_table's form and filter workings.  This can
  # be used to handle nested routing contents, controller actions that
  # behave differently in the presence of certain parameters, etc. withou
  # needing to hack the crap out of data_table.
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

    # this returns all parameters that have been associated with this
    # data_table in flattened form.
    #
    # external parameters that have been included with the :with option
    def exposed_params
      (params||{}).flatten_one_level
    end
    
    def conditions
      @filter.conditions
    end
    
    # FIXME: this needs to be renamed to something more clearly not
    # the view layer
    def options
      @filter.options
    end
    
    def all_options
      form_options||{}
    end
    
    def mode
      form_options && form_options[:form] ? :standard : :ajax
    end
    
    
  end
end