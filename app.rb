require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'mysql'

require './models/rules'
require './models/entities'
require './models/offer'


class API_RANOP_App < Sinatra::Base

  get '/' do
    "API RANOP" 
  end

  get '/entities', :provides => :json do
    @entities = Entities.find(:all, :order => 'nombre')
    @entities.to_json
  end

	get '/entities/:id', :provides => :json do
    @entity = Entities.find(params[:id])
    @entity.to_json
	end

  get '/rules', :provides => :json do
    @rules = Rules.find(:all, :order => 'titulo')
    @rules.to_json
  end

  get '/rules/:id', :provides => :json do
    @rule = Rules.find(params[:id])
    @rule.to_json
  end

  get '/offer', :provides => :json do
    @offers = Offer.find(:all, :order => 'titulo')
    @offers.to_json
  end

  get '/offer/:id', :provides => :json do
    @offer = Offer.find(params[:id])
    @offer.to_json
  end

end