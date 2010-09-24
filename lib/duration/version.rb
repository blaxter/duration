class Duration
  module VERSION
    MAJOR = 0
    MINOR = 1
    TINY  = 2

    STRING = [MAJOR, MINOR, TINY].join('.')
  end
  
  def Duration.version
    VERSION::STRING
  end
end
