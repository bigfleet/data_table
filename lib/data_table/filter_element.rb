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
    @elements = []
  end
  
  def active?
    @selected != @default
  end
  
  def default(label, *args)
    elt = form_element(label, args)
    @default = elt
    @selected = elt
  end
    
  def option(label, *args)
    form_element(label, args)
  end
  
  def with(params)
    param_val = params[@field]
    puts param_val
    return self unless param_val
    @selected = @elements.select{ |e| e.valuize_label == param_val }.first
    return self
  end
  
  def to_html
    select_tag("filter[#{@field}]", options_for_select(@elements.map(&:to_option), @selected.valuize_label), 
                          { :onchange => "submit_function" }.merge(@html_options))
  end
  
  protected
  
  def form_element(label, *args)
    elt = FilterSelection.for(self, args)
    elt.label = label
    @elements << elt
    elt
  end
  
end
