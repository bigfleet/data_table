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
    
    attr_accessor :name, :sort, :filter, :params, :options
    
    def initialize(options)
      @name = options[:name] || "data_table"
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
    
    def nested_params
      params && params[@name] ? params[@name] : {}
    end
    
    # return the relevant options for remote_function calls that are using
    # this data_table
    def options_for_remote_function
      remote_options.merge({:html => html_options})
    end
    
    def remote_options_for_link
      return remote_options if remote_options.empty?
      {:url => remote_options[:url], :update => remote_options[:update]}
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
    
    def condition_options
      @filter.options
    end
    
    def remote_options
      options[:remote].reverse_merge(:method => "get") || {}
    end
    
    def html_options
      options[:html] || {:id => DEFAULT_FORM_ID}
    end
    
    def html_select_options
      html_options[:selects] || {}
    end
    
    def options=(other_options)
      @options = other_options.reverse_merge(:html => {:id => DEFAULT_FORM_ID}, :remote => {:url => ""})
    end
    
    def mode
      options && options[:form] ? :standard : :ajax
    end
    
    def options
      @options || {}
    end
    
    def pagination_url_for(page)
      "foo"
    end
    
    def remote_pagination_options_for(page)
      "bar"
    end
    
    
  end
end