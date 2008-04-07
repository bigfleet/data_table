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
    f = Filter.new(options)
    yield(f)
    return f
  end
  
  
  def conditions(params = {})
    # I'd like to see if we can ingest @params silently,
    # but that may compromise testing
    cond_hash = {}
    active_elements.each {|elt| cond_hash = cond_hash.merge(elt)}
    return cond_hash
  end
  
  protected
  
  def active_elements
    @elements.map{|e| e.with(@params) }.select{ |e| e.activated }
  end
  
end