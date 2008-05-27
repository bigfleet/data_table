require File.dirname(__FILE__) + '/spec_helper'

describe "A standard filter selection" do
  
  describe "simply invoked" do
  
    before(:each) do
      @fs = FilterSelection.for("Blue")
    end
  
    it "should valuize the label correctly" do
      @fs.valuize_label.should == "blue"
    end
  
    it "should use the label valuization as the activation phrase" do
      @fs.phrase.should == "blue"
    end
  
  end
  
end

# TODO: Your day will come, more intricate selections!

# describe "A 'between' filter selection" do
#   
#   before(:each) do
#     @fs = BetweenFilterSelection.new
#   end
#   
#   it "should have a label" do
#     @fs.label = "Testing"
#     @fs.label.should == "Testing"
#   end
#   
#   it "should have an low range value" do
#     @fs.low_range = 1
#     @fs.low_range.should == 1
#   end
#   
#   it "should have a high range value" do
#     @fs.high_range = 10
#     @fs.high_range.should == 10
#   end
#   
# end
# 
# describe "An 'in' filter selection" do
#   
#   before(:each) do
#     @fs = InFilterSelection.new
#   end
#   
#   it "should have a label" do
#     @fs.label = "Testing"
#     @fs.label.should == "Testing"
#   end
#   
#   it "should have an array of acceptable values" do
#     @fs.values = [1,2,3,4]
#     @fs.values.should == [1,2,3,4]
#   end
#   
# end
# 
# describe "A 'time' filter selection" do
#   
#   before(:each) do
#     @fs = TimeFilterSelection.new
#   end
#   
#   it "should have a label" do
#     @fs.label = "Testing"
#     @fs.label.should == "Testing"
#   end
#   
#   it "should indicate how much time has elapsed" do
#     @fs.span = 259200 # 3.days in seconds
#     @fs.span.should == 259200
#   end
#   
# end


