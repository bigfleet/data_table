class SortOption
  
  include ERB::Util
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper  
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::AssetTagHelper
  
  ORDERS = ['asc', 'desc']
  
  # TODO: examine global option for sort icon path
  
  attr_accessor :key, :order, :parent
  
  def initialize(parent, key, order = 'asc')
    @parent = parent
    @key = key
    @order = order || 'asc'
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
    "?key=#{@key}&order=#{order_to_use}"
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
  
  def to_html(options = {})

    sort_icon = assemble_sort_icon(options)
    caption = assemble_caption(options)
    content = [caption, sort_icon].join(" ")
    # FIXME: this should change completely
    
    link_tag = "<a href=\"#{href}\">#{content}</a>"
    content_tag('th', link_tag, options)
  end
  
end