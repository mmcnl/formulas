require './formula_search'

class Formula < ActiveRecord::Base

  def self.search(params)
    find_by_sql( FormulaSearch.prepare_sql(params) )
  end

  def scaled_relevance_ranking
    (rank.to_f * 10).round
  end
  
end
