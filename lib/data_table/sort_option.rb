class SortOption
  
  ORDERS = ['asc', 'desc']
  
  # TODO: examine global option for sort icon path
  
  attr_accessor :key, :preferred_order, :parent, :current_order
  
  def initialize(parent, key, order = 'asc')
    @parent = parent
    @key = key
    @preferred_order = order || 'asc'
    @current_order = nil
  end
  
  # returns whether this option is the currently active sort ordering
  def active?
    self == @parent.selected
  end
  
  # returns the inverse of current_order, or 'desc' by default
  def other_order
    (ORDERS - [current_order]).last
  end
  
  # returns 'asc', 'desc', or nil, depending on the order (or disorder) of
  # this element
  def current_order
    @current_order || (@preferred_order if active?)
  end
  
  def filter
    @parent && @parent.filter ? @parent.filter : nil
  end
  
  def filter_name
    filter ? filter.name : nil
  end
  
end