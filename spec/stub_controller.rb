require File.dirname(__FILE__) + '/../lib/data_table'

class StubController
  
  # Required Rails includes
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper
  
  # Ignore this for now
  def protect_against_forgery?
    
  end
  
  # For our integration tests, we are testing that data table
  # interacts with an object in a certain way.  Since we are
  # currently explicitly requiring the 'uses_data_table' 
  # incantation to mix-in the appropriate methods, it doesn't
  # particularly matter whether the object that we are mixed
  # in with is an ActionController object, provided that we
  # can interface with it in the same way.  
  
  uses_data_table
  
  # For convenience sake during testing, we'll include the view
  # helpers here as well.  This may be *wrong*
  include DataTable::ViewHelpers
  
  
  
  # In this respect, we will need a params method 
  
  attr_accessor :params
  
end