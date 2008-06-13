module DataTable
  module SortViewHelpers
    
    def sort_header(name)
      wrapper = controller.find_data_table_by_name(name).with(params)
      controller.data_tables[name] = wrapper
      wrapper.sort.options.collect do |o| 
        render_sort_option_to_html(o, wrapper.html_options)
      end.join(<<-CR

      CR
      )
    end

    def sort_header_for(data_table_name, key)
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
      url_params = if sort_option.wrapper
        sort_params = {:sort_key => sort_option.key,
                     :sort_order => sort_option.other_order}
        sort_option.wrapper.merged_params(sort_params)
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
      caption = (options && options[:caption]) || Inflector::humanize(sort_option.key).titleize
    end
    
  end
end