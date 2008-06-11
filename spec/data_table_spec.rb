require File.dirname(__FILE__) + '/spec_helper'

describe "a data_table" do
  
  uses_data_table
  
  it "should have optional sorting" do
    self.should respond_to(:filter_spec)
  end
  
  it "should have optional filtering"
  
  it "should wrap pagination with will_paginate"
  
  it "should be able to store standard form submission parameters"
  
  it "should be able to store remote form submission parameters"
  
  it "should be able to generate a hash of all known form data, including full current state"
  
end