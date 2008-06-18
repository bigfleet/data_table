module DataTable
  class LinkRenderer < WillPaginate::LinkRenderer
    
    def initialize(arg1, arg2, arg3)
      # not sure why this is necessary, but it appears to be
      prepare(arg1, arg2, arg3)
    end
    
    # * +collection+ is a WillPaginate::Collection instance or any other object
    #   that conforms to that API
    # * +options+ are forwarded from +will_paginate+ view helper
    # * +template+ is the reference to the template being rendered
    def prepare(collection, options, template)
      @collection = collection
      @data_table = options.delete(:data_table)
      @options    = options
      @template   = template

      # reset values in case we're re-using this instance
      @total_pages = @param_name = @url_string = nil
    end
    
    def page_link_or_span(page, span_class, text = nil)
      text ||= page.to_s
      if page and page != current_page
        case @data_table.mode
        when :standard
          page_link page, text, :rel => rel_value(page), :class => classnames
        else
          @template.link_to_remote text, remote_options_for(page)
        end
      else
        @template.content_tag :span, text, :class => span_class
      end
    end
    
    def url_for(page)
      @template.url_for(@data_table.params_for_url(:page => page))
    end
    
    def remote_options_for(page)
      @data_table.remote_options_with_url(url_for(page))
    end
    
  end
end