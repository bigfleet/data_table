module DataTable

  # A FilterElement plays no part in the public API, although FilterSelection
  # generation via <code>default</code> and <code>option</code> may be of
  # interest.
  # 
  # In the internal workings of data_table, a FilterElement represents a potential
  # filtering of a set of model finder results on a specific column or
  # calculation. It is in charge of being able to address that column or
  # calculation, and to interpret the meaning of any active FilterSelection.
  class FilterElement
  
    attr_accessor :table, :field, :operator, :selected, :default_option, :parent
    attr_reader :selections
  
    def initialize(options = {})
      opts = (options.class == Symbol ? {:field => options} : options)
      @field = opts[:field] || "element_field_must_be_supplied"
      @table = opts[:table]
      @operator = opts[:operator] || "="
      @selections = []
      @parent ||= opts[:parent]
    end
  
    def active?
      !@selected.equal?(@default_option)
    end
  
    def default(label, val=nil)
      elt = form_selection(label, val)
      @default_option = elt
      @selected = elt
    end
    
    def option(label, val=nil)
      form_selection(label, val)
    end

    def with(params = {})
      fe = FilterElement.new(:table => @table, :field => @field, :operator => @operator)
      self.selections.each do |s|
        new_sel = s.clone
        if new_sel.equal?(@default_option)
          fe.default_option = new_sel
          fe.selected = new_sel
        end
        fe.selections << new_sel
      end
      matching_selections = fe.selections.select{ |e| e.valuize_label == param_val(params) }
      fe.selected = matching_selections.first if matching_selections && !matching_selections.empty?
      return fe
    end
  
    def to_hash
      pairs = {}
      pairs[@field] = @selected.phrase
      return pairs
    end
    
    def equal?(other)
      other.field == self.field && other.table == self.table
    end
  
    protected
  
    def form_selection(label, args)
      sel = FilterSelection.for(label, args)
      @selections << sel
      sel
    end
    
    def param_val(params)
      (params[@field] || params[@field.to_s])
    end
    
  
  end
end