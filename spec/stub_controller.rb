require File.dirname(__FILE__) + '/../lib/data_table'

#TODO: This entire class may be subject to elimination
class StubController
  
  # Ignore this for now

  
  # For our integration tests, we are testing that data table
  # interacts with an object in a certain way.  Since we are
  # currently explicitly requiring the 'uses_data_table' 
  # incantation to mix-in the appropriate methods, it doesn't
  # particularly matter whether the object that we are mixed
  # in with is an ActionController object, provided that we
  # can interface with it in the same way.  
  
  uses_data_table
  
  
  
  # In this respect, we will need a params method 
  
  attr_accessor :params
  
end