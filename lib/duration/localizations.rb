require 'duration/locale'
require 'duration/localizations/english'
require 'duration/localizations/korean'
require 'duration/localizations/french'
require 'duration/localizations/dutch'
require 'duration/localizations/polish'

class Duration
  # Contains localizations for the time formatters.  Standard locales cannot be
  # used because they don't define time units.
  module Localizations
    # Default locale
    DEFAULT_LOCALE = :english
    @@locales = {}
    
    # Load all locales.  This is invoked automatically upon loading Duration.
    def Localizations.load_all
      locales = []
      constants.each do |constant|
        mod = const_get(constant)
        next unless mod.kind_of?(Module) and mod.const_defined?('LOCALE')
        
        locale    = mod.const_get('LOCALE').to_sym  # Locale name
        plurals   = mod.const_get('PLURALS')        # Unit plurals
        singulars = mod.const_get('SINGULARS')      # Unit singulars
        
        if mod.const_defined? 'FORMAT'
          format = mod.const_get 'FORMAT'
          format = format.kind_of?(Proc) ? format : proc { |duration| duration.format(format.to_s) }
        end
        
        # Add valid locale to the collection.
        @@locales[locale] = Locale.new(locale, plurals, singulars, format)
      end
    end
    
    # Collection of locales
    def Localizations.locales
      @@locales
    end
  end
  
  class LocaleError < StandardError
  end
end