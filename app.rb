require 'bundler'
Bundler.require
require './formula'
require './db/setup'

class FormulasApp < Sinatra::Base

  def h(string)
    Rack::Utils.escape_html(string)
  end

  get "/" do
    @formulas = Formula.search(params)
    if params[:js]
      haml :_results_table, layout: false
    else
      haml :index
    end
  end

end
