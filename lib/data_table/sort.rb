class Sort
  
  
  # TODO: Sorts and filters, disjoint
  # A sort should be able to survive without a filter, but
  # when they are present together, you shouldn't have to
  # pass the same options in over and over again unless
  # you want specific behavior.
  
  attr_accessor :options, :default_option, :selected, :wrapper
  
  def initialize(_options = {})
    @default_option = nil
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
  
  def option_by_key(key)
    options.select{ |o| o.key == key }.first
  end
  
  def default_key
    @default_option ? @default_option.key : nil
  end
  
  def with(params = {})
    s = Sort.new
    sort_key = params[:sort_key] || default_key
    sort_order = params[:sort_order]
    s.options = @options.collect{|o| o.clone(s) }
    s.default_option = s.options.select{ |o| o.key == self.default_option.key }.first
    s.selected = s.options.select{ |o| o.key == sort_key }.first
    s.selected.current_order = sort_order if sort_order
    s
  end
  
  def options_hash
    @selected.nil? ? @default_option.to_hash : @selected.to_hash
  end  
  
    
  def self.spec(options)
    s = Sort.new(options)
    yield(s)
    return s
  end

end