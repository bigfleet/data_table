module DataTable
  class FilterSelection
  
    attr_accessor :label, :value
    def initialize(label, args)
      @label = label
      @value = (args && !args.empty?) ? args : valuize_label
    end 
    
    def phrase
      @value
    end

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
  
    def self.for(label, args = [])
      FilterSelection.new(label, args)
    end
    
    def equal?(other)
      other.label == self.label && other.value == self.value
    end
  
  end
end