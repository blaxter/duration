class Duration
  module Localizations
    # Dutch localization
    #
    # Thanks to Siep Korteling for this localization.
    module Dutch
      LOCALE    = :dutch
      PLURALS   = %w(seconden minuten uren dagen weken)
      SINGULARS = %w(seconde minuut uur dag week)
      FORMAT    = proc do |duration|
        str = duration.format('%w %~w, %d %~d, %h %~h, %m %~m, %s %~s')
        str.sub(/^0 [a-z]+,?/i, '').gsub(/ 0 [a-z]+,?/i, '').chomp(',').sub(/, (\d+ [a-z]+)$/i, ' en \1').strip
      end
    end
  end
end