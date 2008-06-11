class Sort
  
  
  # TODO: Sorts and filters, disjoint
  # A sort should be able to survive without a filter, but
  # when they are present together, you shouldn't have to
  # pass the same options in over and over again unless
  # you want specific behavior.
  
  attr_accessor :options, :mode, :default_option, :selected, :wrapper
  
  def initialize(_options = {})
    @mode = _options[:mode] || :standard
    @default = nil
    @options = []
  end
  
  def default(key, order = nil)
    e = option(key, order)
    @default_option = e
    @selected = @default_option
  end
  
  def option(key, order = nil)
    opt = SortOption.new(self, key, order)
    @options << opt
    opt
  end
  
  def option_with_name(name)
    options.select{ |o| o.key == name }.first
  end
  
  def default_key
    @default_option ? @default_option.key : nil
  end
  
  def with(params = {})
    s = Sort.new
    active_params = wrapper.nil? ? params : params[wrapper.name] || {}
    sort_key = active_params[:sort_key] || default_key
    sort_order = active_params[:sort_order] || 'asc'
    s.options = @options
    s.selected = s.options.select{ |o| o.key == sort_key }.first
    s.selected.current_order = sort_order
    s
  end
  
    
  def self.spec(options)
    s = Sort.new(options)
    yield(s)
    return s
  end

end