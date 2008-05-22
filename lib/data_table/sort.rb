class Sort
  
  attr_accessor :options, :mode
  
  def initialize(_options)
    @mode = _options[:mode] || :standard
    @options = []
  end
  
  def default(key, order = nil)
    e = option(key, order)
    e.default = true
  end
  
  def option(key, order = nil)
    opt = SortOption.new(key, order)
    @options << opt
    opt
  end
  
    
  def self.spec(options)
    s = Sort.new(options)
    yield(s)
    return s
  end
  
end