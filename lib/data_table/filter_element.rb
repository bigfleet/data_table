gem 'actionpack'
require 'action_controller' #orly?
require 'action_view'

class FilterElement
  
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper  
  include ActionView::Helpers::FormOptionsHelper
  
  attr_accessor :table, :field, :operator, :html_options, :selected, :default
  
  def initialize(_field = nil)
    @field = _field
    @html_options = {}
    @operator = "="
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
  
  def with(params)
    param_val = params[@field]
    return self unless param_val
    @selected = @selections.select{ |e| e.valuize_label == param_val }.first
    return self
  end
  
  def to_html
    select_tag("filter[#{@field}]", options_for_select(@selections.map(&:to_option), @selected.valuize_label), 
                          { :onchange => "submit_function" }.merge(@html_options))
  end
  
  protected
  
  def form_selection(label, *args)
    elt = FilterSelection.for(self, args)
    elt.label = label
    @selections << elt
    elt
  end
  
end
