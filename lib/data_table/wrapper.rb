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
  # url_options: For now, we have to use the old controller/action method
  #              of passing to url_for in view helpers.  Named urls should
  #              be coming soon.
  # remote_options: When using the :ajax mode of operation for data_table,
  #                 these options will be used in any appropriate context
  #                 for remote forms or links
  # html_options: These options will be passed to the various DOM elements
  #               that data_table creates for you.  More docs later.
  # other_options: Use the :with parameter to indicate which "external"
  #                parameters from the request should be included in
  #                data_table
  class Wrapper
    
    DEFAULT_FORM_ID = "filterForm"
    
    attr_accessor :name, :sort, :filter, :params
    attr_accessor :url_options, :remote_options, :html_options, :other_options
    attr_accessor :mode
    
    def initialize(options)
      @name = options[:name] || "data_table"
      @url_options = {}
      @remote_options = {}
      @html_options = {:filter => {:id => "filterForm"}}
      @other_options = {}
      @mode = :ajax
    end
    
    def options=(options = {})
      @remote_options = options.delete(:remote)
      @html_options = options.delete(:html)
      @url_options = options.delete(:url)
      @other_options = options
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
    
    # An ActiveRecord ready array of conditions to be passed
    # to a model finder.
    def conditions
      @filter.nil? ? nil : @filter.conditions
    end
    
    # A sparsely populated options hash (e.g. {:color => nil})
    # corresponding to the conditions method.
    def filter_options
      @filter.nil? ? {} : @filter.options
    end
       
    # The form id to be used for the filter.  Sorts and pagination
    # use links and do not need form submission.
    def form_id
      html_options[:filter][:id]
    end
    
    # receives a set of parameters from a request, and returns a filter
    # with the appropriately activated sort and filter elements.  Retrieving
    # an activated wrapper should be a part of any view helper call.
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
    
    # Examines the state of the options that have been provided to the
    # filter in the context of the request parameters to determine
    # which parameters should be passed to a url_for in a view helper
    def params_for_url(additional_params = {})
      merged_params(additional_params).merge(@url_options)
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
    
    # Takes the parameters that have been used to initialize the table
    # and removes the namespacing effect so that they can more
    # effectively be used in model finders.
    #
    # For example {"cars[color]" => "blue"} would yield "color" => "blue"
    # or possible :color => "blue" depending on how you specified your
    # filter.
    def nested_params
      params && params[@name] ? params[@name] : {}
    end
    
    # Takes in an externally calculated url to be merged in with the
    # existing remote parameters to give a full set of options
    # appropriate for inclusion in link_to_remote or form_remote_tag
    # call in the view helpers
    def remote_options_with_url(url)
      @remote_options.merge(:url => url)
    end
    
  end
end