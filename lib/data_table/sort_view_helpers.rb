module DataTable
  module SortViewHelpers
    
    # TODO: *UGH* including filter_name *FAIL*
    def sort_header(name = nil, options = {})
      scoped_params = params && params[name] ? params[name] : {}
      filter = find_filter(name).with(scoped_params)
      filter.sort.with(scoped_params).options.collect do |o| 
        render_sort_option_to_html(o, options)
      end.join(<<-CR
      
      CR
      )
    end
    
    def render_sort_option_to_html(s, options)
      caption = caption_for(s, options)
      sort_option_url = sort_option_url_for(s, options)
      icon = icon_for(s, options)
      content_tag("td", [caption, link_to(icon, sort_option_url)].join(" "))
      # assemble the bits
    end
    
    def sort_option_url_for(sort_option, options)
      # for the url that we generate, we link to the *opposite* sort
      "?sort_key=#{sort_option.key}&sort_order=#{sort_option.other_order}"
    end

    # examine fetched parameters and set up, determine appearance of sort arrow
    def icon_for(sort_option, options)
      icon = if sort_option.current_order
        "sort_#{sort_option.current_order}"
      else
        "sortArrow001"
      end    
      image_tag("chrome/#{icon}.gif", :alt => "Sort by #{caption_for(sort_option, options)}")
    end

    # examine fetched parameters, options, and set up to determine linked caption
    def caption_for(sort_option, options = {})
      caption = options[:caption] || Inflector::humanize(sort_option.key).titleize
    end
    
  end
end