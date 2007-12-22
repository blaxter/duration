class Duration
  module Localizations
    # French localization
    #
    # Thanks to Jean-François and Fred Senault for this localization.
    module French
      LOCALE    = :french
      PLURALS   = %w(secondes minutes heures jours semaines)
      SINGULARS = %w(seconde  minute  heure  jour  semaine )
      FORMAT    = proc do |duration|
        str = duration.format('%w %~w, %d %~d, %h %~h, %m %~m, %s %~s')
        str.sub(/^0 [a-z]+,?/i, '').gsub(/ 0 [a-z]+,?/i, '').chomp(',').sub(/, (\d+ [a-z]+)$/i, ' et \1').strip
        # Produit un message du genre :
        #  10 semaines, 2 jours, 3 heures, 4 minutes et 5 secondes
      end
    end
  end
end