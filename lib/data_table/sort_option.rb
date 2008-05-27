class SortOption
  
  ORDERS = ['asc', 'desc']
  
  # TODO: examine global option for sort icon path
  
  attr_accessor :key, :preferred_order, :parent, :current_order
  
  def initialize(parent, key, order = 'asc')
    @parent = parent
    @key = key
    @preferred_order = order || 'asc'
    @current_order = nil
  end
  
  # make parameters from sorting, filtering, and pagination locally available in preferred form
  def fetch_parameters
    parms = @parent.params
    parms = parms.reverse_merge({:url => '?'})
    form_options = {:key => @key, :order => @order }
    parms.merge(form_options)
  end
  
  def active?
    self == @parent.selected
  end
  
  def other_order
    other_order = (ORDERS - [@order]).first
  end
  
  def href
    # for the url that we generate, we link to the *opposite* sort
    order_to_use = active? ? other_order : @order
    "?sort_key=#{@key}&sort_order=#{order_to_use}"
  end
  
  # examine fetched parameters and set up, determine appearance of sort arrow
  def assemble_sort_icon(options = {})
    icon = if active?
      "sort_#{@order}"
    else
      "sortArrow001"
    end    
    image_tag("chrome/#{icon}.gif", :alt => "Sort by #{Inflector::humanize(key).titleize}")
  end
  
  # examine fetched parameters, options, and set up to determine linked caption
  def assemble_caption(options = {})
    caption = options.delete(:caption) || Inflector::humanize(key).titleize
  end
  
end