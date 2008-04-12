describe "The data_table plugin" do

  it "requires will_paginate" do
    lambda{
      require 'rubygems'
      gem 'will_paginate'
    }.should_not raise_error
  end
  
  it "should find the data_table plugin to be loadable" do
    lambda{
      load 'data_table'
    }
  end

end