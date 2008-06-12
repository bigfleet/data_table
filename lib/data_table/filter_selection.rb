module DataTable
  class FilterSelection
  
    attr_accessor :label, :value
    
    def phrase
      # FIXME: This is not the finest interface here.
      @value.nil? ? valuize_label : @value.first
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
      sel = FilterSelection.new
      sel.label = label
      sel.value = args
      sel
    end
    
    def equal?(other)
      return false unless other.respond_to?(:label) && other.respond_to?(:value)
      other.label == self.label && other.value == self.value
    end
    
    def clone
      s = FilterSelection.new
      s.label = @label
      s.value = @value
      s
    end
  
  end
end