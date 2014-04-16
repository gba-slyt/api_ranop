require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'mysql'

require './models/rules'
require './models/entities'
require './models/offer'

LOCALITIES  = 1
ORGANISMS   = 3


class API_RANOP_App < Sinatra::Base

  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  get '/' do
    "API RANOP" 
  end

  get '/localities', :provides => :json do
    @entities = Entities.find(:all, :conditions => [ "tipo_entidad_id = ?", LOCALITIES], :order => 'nombre')
    @entities.to_json
  end

  get '/organisms', :provides => :json do
    @entities = Entities.find(:all, :conditions => [ "tipo_entidad_id = ?", ORGANISMS], :order => 'nombre');
    @entities.to_json
  end

  get '/entities', :provides => :json do
    @entities = Entities.find(:all, :order => 'nombre')
    @entities.to_json
  end

	get '/entities/:id', :provides => :json do
    begin
      @entity = Entities.find(params[:id])
      @entity.to_json
      rescue ActiveRecord::RecordNotFound
      status 404
    end
	end

  get '/rules', :provides => :json do
    @rules = Rules.find(:all, :order => 'titulo')
    @rules.to_json
  end

  get '/rule/:id', :provides => :json do
    begin
      @rule = Rules.find(params[:id])
      @rule.to_json
      rescue ActiveRecord::RecordNotFound
      status 404
    end
  end

  get '/offers', :provides => :json do
    @offers = Offer.find(:all, :order => 'titulo')
    @offers.to_json
  end

  get '/offer/:id', :provides => :json do
    begin
      @offer = Offer.find(params[:id])
      @offer.to_json
      rescue ActiveRecord::RecordNotFound
      status 404
    end
  end

  #Error Handling
 
  not_found do
    "404 Not Found"
  end

  error 403 do
    'Access forbidden'
  end

  error 500 do
    'Internal Server Errror'
  end

end