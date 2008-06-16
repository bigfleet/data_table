# sort_header(:cars) do |sort|
#   sort.column :key
# end   

module DataTable
  module SortViewHelpers
    
    class ViewWrapper
      
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormTagHelper
      include ActionView::Helpers::FormOptionsHelper  
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::JavaScriptHelper
      include ActionView::Helpers::PrototypeHelper
      
      attr_reader :wrapper
      
      def initialize(wrapper, controller)
        @wrapper = wrapper
        @controller = controller
      end
      
      def protect_against_forgery?
        @controller.protect_against_forgery?
      end
      
      def mode
        @wrapper.mode
      end
      
      def column(key, options={})
        s = find_sort_key(key)
        caption = caption_for(s, options)
        icon = icon_for(s, options)
        options_params = params_for(s, options)
        link_text = [caption, icon].join(" ")
        case mode
        when :standard
          content_tag("td", link_to(link_text, @controller.url_for(options_params)))
        else
          
          url = @controller.url_for(options_params)
          link_params = @wrapper.remote_options_for_link.merge({:url => url})
          content_tag("td", link_to_remote(link_text, link_params))
        end
        
      end
      
      def params_for(sort_option, options)
        # for the url that we generate, we link to the *opposite* sort
        sort_params = {:sort_key => sort_option.key,
         :sort_order => sort_option.other_order}
        @wrapper.merged_params(sort_params)
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
      
      
      protected 
      
      def find_sort_key(key)
        @wrapper.sort.option_by_key(key) || @wrapper.sort.option_by_key(key.to_s)
      end
      
    end
    
    def sort_header(name, options = {}, &block)
      wrapper = controller.find_data_table_by_name(name).with(params)
      wrapper.options = options
      controller.data_tables[name] = wrapper
      wrp = ViewWrapper.new(wrapper, controller)
      yield wrp
      return wrp
    end
    
  end
end