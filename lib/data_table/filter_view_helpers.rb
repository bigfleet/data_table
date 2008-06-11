module DataTable
  module FilterViewHelpers
    # filter_form takes the following family of options
    # :id   => the ID of the form that contains the filtration selections
    # :form => 
    #    :url => If you desire a standard form submission, provide the url here
    #    :method => The method to use when submitting the form (e.g. GET, POST) 
    # :remote =>
    #    :url => The remote URL to submit to when a filter is selected
    #    :update => The div to update when the new data is available
    #    :method => The method to use when submitting the form (e.g. GET, POST) 
    #    :complete => The method to call when the remote connection is complete
    # :html =>
    #   :label => The introductory label of the filter form
    #   :inner_frame => The options hash of HTML options you'd like the filters inner div to use
    def filter_form(name=nil, options={})
      remote_options = finalize_options(options)
      filter = controller.find_filter(name).with(params)
      form_for_filter(filter, options)
    end
        
    protected
  
    def finalize_options(options)
      remote_options = { 
        :url => options.delete(:url),
        :update => options.delete(:update),
        :method => :get
      }
      options.reverse_merge!({:id => 'filterForm'})
    end
    
    def templates_detected?
      # Should expand a RAILS_ROOT and render the needed 
    end
    
    def form_for_filter(filter, options)
      return unless filter
      return "YAY" if templates_detected?
      return form_for_filter_via_builder(filter, options)
    end
    
    def form_for_filter_via_builder(filter, options)
      xml = Builder::XmlMarkup.new
      html_options = options[:html] || {}
      form_options = (options[:form] || {}).reverse_merge({:url => ""})
      remote_options = (options[:remote] || {}).reverse_merge({:url => "", :method => :get})
      xml.label html_options[:label] if html_options[:label]
      case filter.mode
      when :ajax
        xml << form_remote_tag(remote_options.merge(:html =>{:id => options[:id]}))
      else
        xml << form_tag(form_options[:url], form_options.merge(:id => options[:id]))
      end
      xml.div do |inner_frame|
        filter.elements.inject("") do |memo, elt|
          if options[:remote]
            # AJAX style submission
            submit_function = remote_function(remote_options.merge({:submit => options[:id]}))
            xml << elt.to_html((options[:selects]||{}).merge(:onchange => submit_function))
          else
            # standard style submission
            xml << elt.to_html
          end
        end
      end
      if filter.sort && filter.sort.selected
        active_sort = filter.sort.selected
        xml << hidden_field_tag("#{filter_name}[sort_key]", active_sort.key.to_s, :id => "#{filter.name}_sort_key")
        xml << hidden_field_tag("#{filter.name}[sort_order]", active_sort.current_order.to_s, :id => "#{filter.name}_sort_order")
      end
      if options[:with]
        options[:with].each do |opt|
          xml << hidden_field_tag(opt.to_s, params[opt], :id => "#{filter.name}_#{opt}")
        end
      end
      submit_tag unless filter.mode == :ajax
      xml << "</form>"
    end
  end
end