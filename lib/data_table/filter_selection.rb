class FilterSelection
  attr_accessor :label
  
  def to_hash; {}; end
end

class DefaultFilterSelection < FilterSelection
  attr_accessor :value
  def to_hash; {:value => value }; end
end

class BetweenFilterSelection < FilterSelection
  attr_accessor :low_range, :high_range
  def to_hash; {:type => :between, :low_range => low_range, :high_range => high_range }; end
end

class InFilterSelection < FilterSelection
  attr_accessor :values
  def to_hash; {:type => :in, :low_range => low_range, :high_range => high_range }; end
end

class TimeFilterSelection < FilterSelection
  attr_accessor :anchor, :span, :direction
  def to_hash; {:type => :time, :anchor => anchor, :span => span, :direction => direction }; end
end
