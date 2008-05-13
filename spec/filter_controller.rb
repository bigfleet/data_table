require File.join(File.dirname(__FILE__), 'stub_controller')

class FilterController < StubController
  
  def basic_filter
    filter_spec(:name => :cars) do |f|
      f.element(:colors) do |e|
        e.default "All"
        e.option  "Blue"
        e.option  "Red"
        e.option  "Silver"
        e.option  "Black"
        e.option  "Other"
      end
    end
  end

  def binary_value_filter
    filter_spec(:name => :artists) do |f|
      f.element(:homepage) do |e|
        e.default "All"
        e.option  "with homepage", :when => :not_nil
        e.option  "without homepage", :when => :nil
      end
    end
  end

  def binary_boolean_filter
    filter_spec(:name => :artists) do |f|
      f.element(:taper_friendly) do |e|
        e.default "All"
        e.option  "allow taping", :when => true
        e.option  "do not allow taping", :when => false
      end
    end
  end

  def posession_filter
    filter_spec(:name => :rentals) do |f|
      f.element(:rating) do |e|
        e.default "All"
        e.option  "Rated", :when => true
        e.option  "Unrated", :when => false
      end
    end
  end

  def when_filter
    filter_spec(:name => :live_shows) do |f|
      f.element(:show_date) do |e|
        e.option  "Last 6 months", :since => 6.months.ago
        e.default "This Year", :since => 1.year.ago
        e.option "Last 5 years", :since => 5.years.ago
      end
    end
  end

  def timespan_filter
    filter_spec(:name => :live_shows) do |f|
      f.element(:show_date) do |e|
        e.option  "2000's", :when => {:year => {:between => [2000, :now]}}
        e.option  "1990's", :when => {:year => {:between => [1990, 1999]}}
        e.option  "1980's", :when => {:year => {:between => [1980, 1989]}}
        e.option  "1970's", :when => {:year => {:between => [1970, 1979]}}
      end
    end
  end

  def attribute_count_filter
    filter_spec(:name => :artists) do |f|
      f.element(:album_count) do |e|
        e.default  "1-10", :between => [1, 10]
        e.option  "11-25", :between => [11, 25]
        e.option  "25+", :more_than => [25]
      end
    end
  end

  def projection_filter
    filter_spec(:name => :salesmen) do |f|
      f.element(:sales) do |e|
        e.default  "<100k", :sum => {:order_total => {:between => [1, 100000]}}
        e.option  "100-250k", :sum => {:order_total => {:between => [100000, 250000]}}
        e.option  "25+", :sum => {:order_total => { :more_than => [250000] }}
      end
    end
  end

end
