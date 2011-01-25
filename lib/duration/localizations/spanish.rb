# coding: utf-8
class Duration
  module Localizations
    # Spanish localization
    module Spanish
      LOCALE    = :spanish
      PLURALS   = %w(segundos minutos horas días semanas)
      SINGULARS = %w(segundo minuto hora día semana)
      FORMAT    = proc do |duration|
        str = duration.format('%w %~w, %d %~d, %h %~h, %m %~m, %s %~s')
        str.sub(/^0 [a-zí]+,?/i, '').gsub(/ 0 [a-zí]+,?/i, '').chomp(',').sub(/, (\d+ [a-zí]+)$/i, ' y \1').strip
      end
    end
  end
end
