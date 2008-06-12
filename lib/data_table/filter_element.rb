module DataTable
  class FilterElement
  
    attr_accessor :table, :field, :operator, :selected, :default, :parent
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
      !@selected.equal?(@default)
    end
  
    def default(label, val=nil)
      elt = form_selection(label, val)
      @default = elt
      @selected = elt
    end
    
    def option(label, val=nil)
      form_selection(label, val)
    end
    
    def update_selection_with(params)
      return unless param_val(params)
      @selected = @selections.select{ |e| e.valuize_label == param_val(params) }.first
    end
  

    def with(params = {})
      fe = FilterElement.new(:table => @table, :field => @field, :operator => @operator, 
                                :default => @default, :selected => @default)
      self.selections.each do |s|
        fe.selections << s.clone
      end
      fe.selected = fe.selections.select{ |e| e.valuize_label == param_val(params) }.first
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