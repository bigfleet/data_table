module DataTable

  # A Filter is a component managed completely by the Wrapper object at this
  # point. This class is irrelevant to the public API, although element
  # generation via the <code>element</code> method may be useful to review.
  # 
  # For the internals of data_table, a Filter is a collection of many
  # FilterElements. Its primary task is to organize and inspect these elements in
  # various contexts and to communicate the results of that inspection to the
  # Wrapper.
  class Filter
  
    attr_accessor :elements, :wrapper
  
    def initialize(options = {})
      @elements = []
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
    
    def with(params = {})
      f = Filter.new
      @elements.each do |elt|
        f.add_element(elt.with(params))
      end
      f
    end
  
    # conditions are clauses like ["make = ?", ?] or something that could be
    # used in an ActiveRecord context directly
    def conditions
      return nil unless active_elements && !active_elements.empty?
      all_conds = active_elements.collect {|elt| 
          ["#{elt.field} #{elt.operator} ?", elt.selected.phrase] 
      }
      all_conds.flatten # that's all for now-- combine later
    end
    

    
    # returns an options hash, for greater flexibility.
    def options
      cond_hash = {}
      parms = @params && @params[@name] ? @params[@name] : {}
      actives = active_elements
      actives.each {|elt| cond_hash = cond_hash.merge(elt)} if actives
      idles = @elements - actives
      idles.each { |elt| cond_hash = cond_hash.merge({elt.field => nil})}
      return cond_hash
    end
  
    # Like to be protected maybe?
    #protected
  
    def active_elements
      @elements.select{ |e| e.active? }
    end
    
    protected
    
    def add_element(elt)
      elt.parent = self
      @elements << elt
    end
  
  end
end