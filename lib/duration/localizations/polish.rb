# coding: utf-8
class Duration
  module Localizations
    # Polish localization
    #
    # Thanks to Marcin Raczkowski for this localization.
    module Polish
      LOCALE    = :polish
      PLURALS   = %w(sekundy minuty godziny dni tygodni)
      SINGULARS = %w(sekunda minuta godzina dzień tydzień)
      FORMAT    = proc do |duration|
    	  str = duration.format('%w %~w, %d %~d, %h %~h, %m %~m, %s %~s')
    	  str.sub(/^0 [a-z]+,?/i, '').gsub(/ 0 [a-z]+,?/i, '').chomp(',').sub(/, (\d+ [a-z]+)$/i, ' i \1').strip
    	  # Daje w wyniku np.
    	  #  10 tygodni, 2 dni, 3 godziny, 4 minuty i 5 sekund
      end
    end
  end
end
