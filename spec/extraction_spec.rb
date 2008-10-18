require File.dirname(__FILE__) + '/spec_helper'

describe "An extracted data_table" do

  uses_data_table

  before(:each) do
    @trades = mock(Array)
    @trades.should_receive(:find).with(:group => :trade_type).and_return(different_trades)
    @trades.should_receive(:find).with(:group => :symbol).and_return(different_trades)
    @trades.should_receive(:find).with(:group => :strike_price_in_cents).and_return(different_trades)    
    invoke_data_table
    @trade_table = data_table(:trades)
  end

  it "should parse and execute successfully" do
    @trade_table.should_not be_nil
  end
  
  it "should provide 5 filter elements" do
    @trade_table.filter_options.should have(5).things
  end
  

  describe "the trade type filter" do
    
    before(:each) do
      @trade_type_element = @trade_table.filter.elements.detect{|e| e.field == :trade_type }
    end
    
    it "should be findable" do
      @trade_type_element.should_not be_nil
    end
    
    it "should have a default label" do
      @trade_type_element.selected.label.should == "Trades"
    end
    
    it "should have results based on mock" do
      @trade_type_element.selections.should have_at_least(3).things
      @trade_type_element.selections.select{ |s| s.label == "buyopen"}.should_not be_nil
      @trade_type_element.selections.select{ |s| s.label == "sellclose"}.should_not be_nil      
    end
    
  end

  protected
  
  def mock_trade(options = {})
    options[:symbol] ||= "V OR"
    options[:trade_type] ||= "buyopen"
    options[:strike_price_in_cents] ||= 2000
    trade = mock(Object)
    trade.stub!(:symbol).and_return(options[:symbol])
    trade.stub!(:trade_type).and_return(options[:trade_type])
    trade.stub!(:strike_price_in_cents).and_return(options[:strike_price_in_cents])
    trade
  end
  
  def different_trades
    [mock_trade, 
      mock_trade(:trade_type => 'sellclose'), 
      mock_trade(:symbol => "V AD", :strike_price_in_cents => 2500)]
  end

  def invoke_data_table
    params = {:options => true}
    data_table(:trades) do |table|
      table.filter_spec do |f|
        f.element(:etype) do |e|
          e.default "All"
          e.option  "Equities", 'stock'
          e.option  "Options",  'option'
        end
        f.element(:trade_type) do |e|
          e.default "Trades"
          options_group_from(@trades, :group => :trade_type) do |t|
            e.option t.trade_type
          end
        end
        f.element(:symbol) do |e|
          options_group_from(@trades, :group => :symbol) do |t|
            e.option t.symbol
          end
        end
        if params[:options]
          f.element(:otype) do |e|
            e.default "Type"
            e.option  "Call", 'call'
            e.option  "Put" , 'put'
          end
          f.element(:strike_price_in_cents) do |e|
            options_group_from(@trades, :group => :strike_price_in_cents) do |t|
              e.option t.strike_price_in_cents
            end
          end
        end
      end
    end
  end
  
end