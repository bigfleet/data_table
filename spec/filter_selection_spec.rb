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
  
  before(:each) do
    @fs = BetweenFilterSelection.new
  end
  
  it "should have a label" do
    @fs.label = "Testing"
    @fs.label.should == "Testing"
  end
  
  it "should have an low range value" do
    @fs.low_range = 1
    @fs.low_range.should == 1
  end
  
  it "should have a high range value" do
    @fs.high_range = 10
    @fs.high_range.should == 10
  end
  
end

describe "An 'in' filter selection" do
  
  before(:each) do
    @fs = InFilterSelection.new
  end
  
  it "should have a label" do
    @fs.label = "Testing"
    @fs.label.should == "Testing"
  end
  
  it "should have an array of acceptable values" do
    @fs.values = [1,2,3,4]
    @fs.values.should == [1,2,3,4]
  end
  
end

describe "A 'time' filter selection" do
  
  before(:each) do
    @fs = TimeFilterSelection.new
  end
  
  it "should have a label" do
    @fs.label = "Testing"
    @fs.label.should == "Testing"
  end
  
  it "should indicate how much time has elapsed" do
    @fs.span = 259200 # 3.days in seconds
    @fs.span.should == 259200
  end
  
end


