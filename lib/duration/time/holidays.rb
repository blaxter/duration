class Time
  module Holidays
    # Time object for this Christmas.
    def christmas
      local(Time.now.year, 12, 25)
    end
    
    # Time object to new years day.
    def new_years
      local(Time.now.year + 1, 1)
    end
    
    alias_method :xmas, :christmas
    alias_method :newyears, :new_years
  end
end