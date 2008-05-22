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
      return nil unless params and params[@name]
      parms = params[@name]
      all_conds = active_elements(parms).map {|elt| 
          ["#{elt.field} #{elt.operator} ?", elt.selected.phrase] 
      }
      all_conds.flatten # that's all for now-- combine later
    end
    

    
    # returns an options hash, for greater flexibility.
    def options(params = {})
      cond_hash = {}
      parms = params && params[@name] ? params[@name] : {}
      actives = active_elements(parms)
      actives.each {|elt| cond_hash = cond_hash.merge(elt)}
      idles = @elements - actives
      idles.each { |elt| cond_hash = cond_hash.merge({elt.field => nil})}
      return cond_hash
    end
  
    # Like to be protected maybe?
    #protected
  
    def active_elements(params = {})
      @elements.map{|e| e.with(params) }.select{ |e| e.active? }
    end
  
  end
end