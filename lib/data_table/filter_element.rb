gem 'actionpack'
require 'action_controller' #orly?
require 'action_view'

module DataTable
  class FilterElement
  
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper  
    include ActionView::Helpers::FormOptionsHelper
  
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
  
    def default(label, *args)
      elt = form_selection(label, args)
      @default = elt
      @selected = elt
    end
    
    def option(label, *args)
      form_selection(label, args)
    end
    
    def update_selection_with(params)
      return unless param_val(params)
      @selected = @selections.select{ |e| e.valuize_label == param_val(params) }.first
    end
  

    def with(params = {})
      update_selection_with(params)
      return self
    end
  
    # TODO: Deprecate this and move it to the view helper
    def to_html(options = {})
      select_tag("#{@parent.name}[#{@field}]", 
                    options_for_select(@selections.map(&:to_option), @selected.valuize_label), 
                    options)
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