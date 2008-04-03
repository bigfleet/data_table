class FilterElement
  
  attr_accessor :table, :field, :operator, :html_options, :selected
  
  def initialize
    @operator = "="
    @elements = []
  end
  
  def default(label, *args)
    @selected = form_element(label, args)
  end
    
  def option(label, *args)
    form_element(label, args)
  end
  
  protected
  
  def form_element(label, *args)
    elt = FilterSelection.for(self, args)
    elt.label = label
    @elements << elt
    elt
  end
  
end
