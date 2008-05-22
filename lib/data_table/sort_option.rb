class SortOption
  
  attr_accessor :key, :order, :default
  
  def initialize(key, order = 'asc')
    self.key = key
    self.order = order
  end
  
end