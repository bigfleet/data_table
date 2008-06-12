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
      wrapper = controller.find_data_table_by_name(name)
      wrapper.form_options = remote_options
      form_for_filter(wrapper)
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
    
    def templates_detected?(wrapper)
      # Should expand a RAILS_ROOT and render the needed 
    end
    
    def form_for_filter(wrapper)
      return unless wrapper && wrapper.filter
      return "YAY" if templates_detected?(wrapper)
      return form_for_filter_via_builder(wrapper)
    end
    
    def form_for_filter_via_builder(wrapper)
      filter = wrapper.filter
      # some of this code should be moved to the wrapper to make this as easy as possible.
      xml = Builder::XmlMarkup.new
      case wrapper.mode
      when :ajax
        remote_options = wrapper.remote_options
        xml << form_remote_tag(remote_options.merge(:html =>{:id => options[:id]}))
      else
        form_options = wrapper.form_options
        xml << form_tag(form_options[:url], form_options.merge(:id => options[:id]))
      end
      xml.div do
        filter.elements.each do |memo, elt|
          case wrapper.mode
          when :ajax
            # AJAX style submission
            submit_function = remote_function(remote_options.merge({:submit => options[:id]}))
            elt_html = element_to_html(elt, filter.wrapper.name, (options[:selects]||{}).merge(:onchange => submit_function))
            xml << elt_html
          else
            # standard style submission
            xml << element_to_html(elt, filter.wrapper.name)
          end
        end
      end
      if wrapper.sort && wrapper.sort.selected
        active_sort = wrapper.sort.selected
        name = wrapper.name
        xml << hidden_field_tag("#{name}[sort_key]", active_sort.key.to_s, :id => "#{name}_sort_key")
        xml << hidden_field_tag("#{name}[sort_order]", active_sort.current_order.to_s, :id => "#{name}_sort_order")
      end
      if options[:with]
        options[:with].each do |opt|
          xml << hidden_field_tag(opt.to_s, params[opt], :id => "#{wrapper.name}_#{opt}")
        end
      end
      submit_tag unless wrapper.mode == :ajax
      xml << "</form>"
    end
  end
  
  def element_to_html(sort_element, nest_name, options = {})
    select_tag("#{nest_name}[#{sort_element.field}]", 
                  options_for_select(sort_element.selections.map(&:to_option), sort_element.selected.valuize_label), 
                  options)
  end
end