require File.dirname(__FILE__) + '/spec_helper'

describe "A standard filter selection" do
  
  before(:each) do
    @fs = DefaultFilterSelection.new
  end
  
  it "should have a label" do
    @fs.label = "Testing"
    @fs.label.should == "Testing"
  end
  
  it "should have a specified value" do
    @fs.value = "Testing"
    @fs.value.should == "Testing"
  end  
end

describe "A 'between' filter selection" do
  
  it "should have a label" do
    @fs.label = "Testing"
    @fs.label.should == "Testing"
  end
  
  it "should have an low range value"
  
  it "should have a high range value"
  
end

describe "An 'in' filter selection" do
  
  it "should have a label" do
    @fs.label = "Testing"
    @fs.label.should == "Testing"
  end
  
  it "should have an array of acceptable values"
  
end

describe "A 'time' filter selection" do
  
  it "should have a label" do
    @fs.label = "Testing"
    @fs.label.should == "Testing"
  end
  
  it "should have a time anchor to use for comparison"
  
  it "should indicate how much time has elapsed"
  
  # e.g. three days before <date>, three days from <date>
  it "should indicate in which direction time has elapsed"
  
end

