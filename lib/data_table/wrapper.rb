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
  # Known options:
  #
  # :selects => HTML styling to be applied to the select inputs in a filter
  #             form
  # 
  # :with => See below
  # 
  # Of course, to make this interesting, there is one exception.  The :with
  # option allows the client code to define a set of parameters that will
  # be included in any of data_table's form and filter workings.  This can
  # be used to handle nested routing contents, controller actions that
  # behave differently in the presence of certain parameters, etc. withou
  # needing to hack the crap out of data_table.
  #
  # Note:  the default rendering mode is Ajax.  That's the only one well
  # supported right now
  class Wrapper
    
    DEFAULT_FORM_ID = "filterForm"
    
    attr_accessor :name, :sort, :filter, :params
    attr_accessor :url_options, :remote_options, :html_options, :other_options
    
    def initialize(options)
      @name = options[:name] || "data_table"
      @url_options = {}
      @remote_options = {}
      @html_options = {:filter => {:id => "filterForm"}}
      @other_options = {}
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
      w.params = params
      if @sort
        w.sort = @sort.with(w.nested_params)
        w.sort.wrapper = self
      end
      if @filter
        w.filter = @filter.with(w.nested_params)
        w.filter.wrapper = self
      end
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
      return {@name => other_hash}.flatten_one_level unless params && params[@name]
      named_params = params[@name]
      {@name => (named_params.merge(other_hash))}.flatten_one_level
    end
    
    # def nested_params
    #   params && params[@name] ? params[@name] : {}
    # end
    # 
    # # this returns all parameters that have been associated with this
    # # data_table in flattened form.
    # #
    # # external parameters that have been included with the :with option
    # def exposed_params
    #   (params||{}).flatten_one_level
    # end
    
    def conditions
      @filter.nil? ? nil : @filter.conditions
    end
    
    def filter_options
      @filter.nil? ? {} : @filter.options
    end
        
    def form_id
      html_options[:filter][:id]
    end
    
    # Examines the state of the options that have been provided to the
    # filter in the context of the request parameters to determine
    # which parameters should be passed to a url_for in a view helper
    def params_for_url(additional_params = {})
      return additional_params
    end
    
  end
end