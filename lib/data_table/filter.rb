module DataTable
  class Filter
  
    attr_accessor :name, :elements, :mode, :sort
  
    def initialize(options = {})
      @name = options[:name] || "filter"
      @elements = []
      @mode = options[:mode] || :standard
    end
  
    def element(options)
      elt = FilterElement.new(options)
      elt.parent = self
      yield(elt)
      @elements << elt
    end
  
    def self.spec(options)
      f = Filter.new(options)
      yield(f)
      return f
    end
  
    # conditions are clauses like ["make = ?", ?] or something that could be
    # used in an ActiveRecord context directly
    def conditions(params = {})
      # figure out if we can get params directly from ActionController
      return nil unless params and params[:filter]
      cond_hash = {}
      parms = params[:filter][@name]
      active_elements(parms).each {|elt| cond_hash = cond_hash.merge(elt)}
      return cond_hash
    end
    

    
    # returns an options hash, for greater flexibility.
    def options(params = {})
      act_elts = active_elements
      idle_elts = @elements - act_elts
      idle_options = idle_elts.inject({}){|acc, elt| acc.merge({elt.field => nil})}
      idle_options.merge(active_options)
    end
  
    # Like to be protected maybe?
    #protected
  
    def active_elements(params = {})
      @elements.map{|e| e.with(params) }.select{ |e| e.active? }
    end
    
    def active_options
      active_elements.inject({}){|acc, elt| acc.merge(elt.to_hash)}
    end
  
  end
end