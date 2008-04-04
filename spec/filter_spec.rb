describe "A filter" do
  
  before(:each) do
    @f = Filter.new
  end
  
  it "should consist of a set of filter elements"
  
  it "should allow filter elements to be added"
  
  it "should produce a hash of selected options"
  
  it "should be skinnable"
  
  it "should ensure filter elements are serialized along with sort options"
  
  it "should allow for choosing between AJAX and non-AJAX modes"
  
  it "should allow setting the default AJAX mode"
  
  describe "when fully initialized" do
    before(:each) do
      @f = Filter.spec(:name => "testing") do |f|
        f.element(:etype) do |e|
          e.default  "Equities + Options", nil
          e.option   "Equities",          'stock'
          e.option   "Options",           'option'
        end
      end
      
    end
  end
  
end