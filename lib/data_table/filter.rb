module DataTable
  
  # The Filter objects role is that of the manager of filter elements and options
  # Without parameters, it will respect the defaults of the filtering specification
  # that the client application provides.  When provided with the parameters
  # (usually the params from the incoming request) via the <code>with</code>
  # method, the filter will reconfigure itself to reflect the selections that
  # have been made.
  #
  # In either of the above cases, the filter is also responsible for two forms
  # of communication with its natural partner: the ActiveRecord finder.  The
  # <code>conditions</code> method will be appropriate for direct inclusion
  # in the :conditions phrase of <code>ActiveRecord.find</code> calls.  The
  # <code>options</code> method is meant as a fall-back or workaround when
  # things get hairy.  It provides a hash that a finder method can process
  # and act on in a manner of its choosing
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