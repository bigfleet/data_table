module DataTable
  class Filter
  
    attr_accessor :name, :elements, :mode
  
    def initialize(options = {})
      @name = options[:name] || "filter"
      @elements = []
      @mode = options[:mode] || :standard
    end
  
    def element(options)
      elt = FilterElement.new(options)
      yield(elt)
      @elements << elt
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
      parms = params[:filter][@name]
      active_elements(parms).each {|elt| cond_hash = cond_hash.merge(elt)}
      return cond_hash
    end
  
    # Like to be protected maybe?
    #protected
  
    def active_elements(params = {})
      @elements.map{|e| e.with(params) }.select{ |e| e.active? }
    end
  
  end
end