module DataTable
  module SortViewHelpers
    
    # TODO: *UGH* including filter_name *FAIL*
    def sort_header(name = nil, options = {})
      scoped_params = params && params[name] ? params[name] : {}
      filter = controller.find_filter(name).with(scoped_params)
      filter.sort.with(scoped_params).options.collect do |o| 
        render_sort_option_to_html(o, options)
      end.join(<<-CR

      CR
      )
    end

    def sort_header_for(filter_name, &block)
      scoped_params = params && params[filter_name] ? params[filter_name] : {}
      filter = controller.find_filter(filter_name).with(scoped_params)
      yield(filter.sort.with(scoped_params))
    end

    def key_for(sort, option_key, options)
      opt = sort.option_with_name(option_key)
      render_sort_option_to_html(opt, options)
    end
    
    def render_sort_option_to_html(s, options)
      caption = caption_for(s, options)
      sort_option_url = sort_option_url_for(s, options)
      icon = icon_for(s, options)
      content_tag("td", [caption, link_to(icon, sort_option_url)].join(" "))
      # assemble the bits
    end
    
    def flatten_hash(hsh)
      nest_key = hsh.keys.first
      nested = hsh.values.first
      result_hash = {}
      nested.map{ |o| result_hash[nest_key.to_s+'['+o.first.to_s+"]"] = o.last.to_s }
      result_hash
    end
    
    def sort_option_url_for(sort_option, options)
      # for the url that we generate, we link to the *opposite* sort
      base_url = "?"
      url_params = if sort_option.filter
        sort_opts = {sort_option.filter_name => {:sort_key => sort_option.key,
                                     :sort_order => sort_option.other_order}}
        sort_opts.merge(sort_option.filter.exposed_params)
      else
        {:sort_key => sort_option.key,
         :sort_order => sort_option.other_order}
      end
      # still need to get these filtered in with filter options
      #{}"?sort_key=#{sort_option.key}&sort_order=#{sort_option.other_order}"
      controller.url_for(url_params)
    end

    # examine fetched parameters and set up, determine appearance of sort arrow
    def icon_for(sort_option, options)
      icon = if sort_option.current_order
        "sort_#{sort_option.current_order}"
      else
        "sortArrow001"
      end    
      image_tag("chrome/#{icon}.gif", :border => 0, :alt => "Sort by #{caption_for(sort_option, options)}")
    end

    # examine fetched parameters, options, and set up to determine linked caption
    def caption_for(sort_option, options = {})
      caption = options[:caption] || Inflector::humanize(sort_option.key).titleize
    end
    
  end
end