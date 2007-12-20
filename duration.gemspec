$:.unshift './lib'
require 'duration/version'

Gem::Specification.new do |spec|
  spec.name               = 'duration'
  spec.version            = Duration::VERSION
  spec.author             = 'Matthew Harris'
  spec.email              = 'matt@matthewharris.org'
  spec.homepage           = 'http://duration.rubyforge.org'
  spec.summary            = 'Duration/timespan manipulation library'
  spec.rubyforge_project  = 'duration'
  spec.autorequire        = 'duration'
  spec.files              = Dir['lib/**/*.rb']
  spec.has_rdoc           = true
  spec.extra_rdoc_files   = %w(README LICENSE)
  
  spec.rdoc_options       << '--title' << 'Duration -- The Timespan Library'\
                          << '--main'  << 'README'\
                          << '--line-numbers'
                          
  spec.description        = %[
    Duration is a library for manipulating timespans.  It can give you readable
    output for a timespan as well as manipulate the timespan itself.  With this
    it is possible to make "countdowns" or "time passed since" type objects.
  ]
end