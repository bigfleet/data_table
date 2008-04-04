class FilterSelection
  
  attr_accessor :label
  
  def to_hash; {}; end
  
  def escape(str)
    s = str.dup
    s.gsub!(/\W+/, ' ') # all non-word chars to spaces
    s.strip!            # ohh la la
    s.downcase!         #
    s.gsub!(/\ +/, '-') # spaces to dashes, preferred separator char everywhere
    s
  end
  
  def valuize_label
    escape(@label)
  end
  
  def to_option
    [@label, valuize_label]
  end
  
  def self.for(element, *args)
    case element.operator
    when "IN"
      InFilterSelection.new(args)
    when "BETWEEN"
      BetweenFilterSelection.new(args.first, args.last)
    else
      DefaultFilterSelection.new(args)
    end
  end
  
end

class DefaultFilterSelection < FilterSelection
  attr_accessor :value
  def initialize(args = nil); @value = args; end 
  def to_hash; {:value => value }; end
end

class BetweenFilterSelection < FilterSelection
  attr_accessor :low_range, :high_range
  def initialize(low = nil, high = nil); @low_range = low; @high_range = @high end  
  def to_hash; {:low_range => low_range, :high_range => high_range }; end
end

class InFilterSelection < FilterSelection
  attr_accessor :values
  def initialize(args = nil); @values = args; end   
  def to_hash; {:values => values }; end
end

class TimeFilterSelection < FilterSelection
  attr_accessor :span
  def initialize(args = nil); @span = args; end     
  def to_hash; {:span => span }; end
end
