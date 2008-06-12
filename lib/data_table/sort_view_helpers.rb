module DataTable
  module SortViewHelpers
    
    def sort_header(name)
      data_table = controller.find_data_table_by_name(name).with(params)
      data_table.sort.with(params).options.collect do |o| 
        render_sort_option_to_html(o, options)
      end.join(<<-CR

      CR
      )
    end

    def sort_header_for(name, &block)
      controller.find_data_table_by_name(name).with(params)
      yield(data_table(name).sort)
    end

    def key_for(sort, option_key, options)
      opt = sort.option_with_name(option_key)
      render_sort_option_to_html(opt, options)
    end
    
    def render_sort_option_to_html(s, options)
      caption = caption_for(s, options)
      sort_option_url = sort_option_url_for(s, options)
      icon = icon_for(s, options)
      content_tag("td", link_to([caption, icon].join(" "), sort_option_url))
    end
    
    def sort_option_url_for(sort_option, options)
      # for the url that we generate, we link to the *opposite* sort
      url_params = if sort_option.filter
        sort_params = {:sort_key => sort_option.key,
                     :sort_order => sort_option.other_order}
        filter_params = sort_option.filter.filtered_params
        all_params = if filter_params 
          sort_params.merge(filter_params)
        else
          sort_params
        end
        {sort_option.filter_name => all_params}.flatten_one_level
      else
        {:sort_key => sort_option.key,
         :sort_order => sort_option.other_order}
      end
      controller.url_for(url_params)
    end

    # render the appropriate icon for this sort option based on current sorting and state
    def icon_for(sort_option, options)
      icon = if sort_option.current_order
        "sort_#{sort_option.current_order}"
      else
        "sortArrow001"
      end    
      image_tag("chrome/#{icon}.gif", :border => 0, :alt => "Sort by #{caption_for(sort_option, options)}")
    end

    # Determine caption for option, can be overriden by a <code>:caption</code> option
    def caption_for(sort_option, options = {})
      caption = options[:caption] || Inflector::humanize(sort_option.key).titleize
    end
    
  end
end