# TODO: extract this and the DB setup tasks into a gem for easy 
#         full-text searching on free Heroku accounts

module FormulaSearch

  # Public: Generate an array (containing a SQL template with placeholders
  #           and 4 variable bind strings) for use by Formula.find_by_sql
  #
  # params - hash of submitted form values
  #
  #   FormulaSearch.prepare_sql(  symptoms:   'Abdominal Distention',
  #                               pulse:      'Rapid, Choppy...',
  #                               tongue:     'red',
  #                               diagnosis:  'KID Yang deficiency' ) 
  #
  #   # => [ "SELECT pinyin, pinyin_plain ... where rank > 1;",
  #          "abdomen|abdominal|bloating|distention", 
  #          "rapid|choppy", 
  #          "red",
  #          "kid|yang|xu|deficiency" ]
  #
  # Returns the array
  def self.prepare_sql(params)
    [ SQL_TEMPLATE, 
      make_bind_string(params[:symptoms]), 
      make_bind_string(params[:pulse]), 
      make_bind_string(params[:tongue]), 
      make_bind_string(params[:diagnosis]) ]    
  end

  def self.make_bind_string(phrase)
    synonymize( sanitize(phrase) ).join(' ').split.join('|')
  end
  def self.sanitize(phrase)
    phrase.to_s.downcase.gsub(/[^a-z ]/,' ').split.compact
  end
  def self.synonymize(terms)
    terms.map { |t| SYNONYMS.grep(/\b#{t}\b/).first || t }.uniq
  end

  RESULTS_TO_FETCH = 7

  SQL_TEMPLATE = "SELECT pinyin, pinyin_plain, chinese_characters, category, symptoms_highlighted, tongue_highlighted, pulse_highlighted, diagnosis_highlighted, rank from (select *,  
          ( ts_rank_cd(ft_symptoms::tsvector, symptoms_query) + 
            ts_rank_cd(ft_pulse::tsvector, pulse_query) + 
            ts_rank_cd(ft_tongue::tsvector, tongue_query) + 
            ts_rank_cd(ft_diagnosis::tsvector, diagnosis_query) + 
            (impt + req_state_board)/2 ) AS rank, 
            ts_headline(symptoms, symptoms_query, 'HighlightAll = true') as symptoms_highlighted,
            ts_headline(tongue, tongue_query, 'HighlightAll = true') as tongue_highlighted,
            ts_headline(diagnosis, diagnosis_query, 'HighlightAll = true') as diagnosis_highlighted,
            ts_headline(pulse, pulse_query, 'HighlightAll = true') as pulse_highlighted
          FROM formulas, 
            to_tsquery('english', ? ) symptoms_query,
            to_tsquery('english', ? ) pulse_query,
            to_tsquery('english', ? ) tongue_query,
            to_tsquery('english', ? ) diagnosis_query
           ORDER BY rank DESC LIMIT #{RESULTS_TO_FETCH}) subselect where rank > 1;"

 SYNONYMS = [  
            ### DX
            'BL UB bladder', 
            'GB gallbladder', 
            'HT heart', 
            'KD Kidney KID', 
            'LR LIV liver', 
            'LU lung', 
            'SP spleen', 
            'ST stomach', 
            ### SX
            'abdomen abdominal',
            'bloating distention',
            'copious profuse',
            'diarrhea loose-stools',
            'exterior external',
            'fatigue tired exhaustion',
            'insomnia sleep',
            'interior internal',
            'phlegm mucus sputum',
            'PMS premenstrual menstruation menstrual dysmenorrhea menses',
            'SOB shortness breath',
            'stasis stagnation constraint', 
            'vexation irritable anger angry',
            'xu deficiency',
            #### TONGUE
            'dusky purple purplish', 
            'enlarged puffy swollen', 
            'scalloped toothmarks teethmarks', 
            ### PULSES
            'choppy rough', 
            'rapid fast', 
            'slippery rolling', 
            'soggy soft', 
            'floating superficial', 
            'flooding overflowing surging', 
            'frail weak faint minute forceless empty vacuous deficient', 
            'excess full forceful strong pounding',
            'thin fine thready' 
          ]             
end

