gem 'actionpack'
require 'action_controller' #orly?
require 'action_view'

class FilterElement
  
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper  
  include ActionView::Helpers::FormOptionsHelper
  
  attr_accessor :table, :field, :operator, :html_options, :selected, :default
  attr_reader :selections
  
  def initialize(options = {})
    opts = (options.class == Symbol ? {:field => options} : options)
    @field = opts[:field] || "element_field_must_be_supplied"
    @table = opts[:table]
    @html_options = opts[:html_options] || {}
    @operator = opts[:operator] || "="
    @selections = []
  end
  
  def active?
    @selected != @default
  end
  
  def default(label, *args)
    elt = form_selection(label, args)
    @default = elt
    @selected = elt
  end
    
  def option(label, *args)
    form_selection(label, args)
  end
  
  def with(params = {})
    param_val = params[@field]
    return self unless param_val
    @selected = @selections.select{ |e| e.valuize_label == param_val }.first
    return self
  end
  
  def to_html
    select_tag("filter[#{@field}]", options_for_select(@selections.map(&:to_option), @selected.valuize_label), 
                          { :onchange => "submit_function" }.merge(@html_options))
  end
  
  def to_hash
    pairs = {}
    pairs[@field] = @selected.phrase
    return pairs
  end
  
  protected
  
  def form_selection(label, args)
    elt = FilterSelection.for(self, args)
    elt.label = label
    @selections << elt
    elt
  end
  
end
