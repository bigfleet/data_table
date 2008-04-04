class Filter
  
  attr_accessor :name, :elements, :mode
  
  def initialize(options = {})
    @name = options[:name] || "filter"
    @elements = []
    @mode = options[:mode] || :standard
  end
  
  def element(options)
    elt = FilterElement.new
  end
  
  def self.spec(options)
    yield(Filter.new(options))
  end
  
end