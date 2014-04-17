require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/jbuilder'
require 'json'

require './models/rules'
require './models/entities'
require './models/offer'


LOCALITIES  = 1
ORGANISMS   = 3


class API_RANOP_App < Sinatra::Base

  get '/' do
    "API RANOP" 
  end

  ### Localidades

  get '/localities', :provides => :json do
    @localities = Entities.where("tipo_entidad_id = :tipo_entidad_id", {tipo_entidad_id: LOCALITIES}).order('nombre DESC')
    @localities.to_json
  end

  get '/locality/:id', :provides => :json do
    begin
      @locality = Entities.where("tipo_entidad_id = :tipo_entidad_id AND id = :id",{tipo_entidad_id: LOCALITIES, id: params[:id]})
      # @locality.to_json
      jbuilder :'localities/show'
    rescue ActiveRecord::RecordNotFound
      status 404
    end
  end

  ### Organismos

  get '/organisms', :provides => :json do
    @entities = Entities.where("tipo_entidad_id = :tipo_entidad_id", {tipo_entidad_id: ORGANISMS}).order('nombre DESC')
    @entities.to_json
  end

  get '/organism/:id', :provides => :json do
    begin
      @organism = Entities.where("tipo_entidad_id = :tipo_entidad_id AND id = :id", {tipo_entidad_id: ORGANISMS, id: params[:id]})
      @organism.to_json
    rescue ActiveRecord::RecordNotFound
      status 404
    end
  end

  ### Entidades (Localidades y Organismos)

  get '/entities', :provides => :json do
    @entities = Entities.find(:all, :order => 'nombre')
    @entities.to_json
  end

	get '/entity/:id', :provides => :json do
    begin
      @entity = Entities.find(params[:id])
      @entity.to_json
      entity_url(@entity)
    rescue ActiveRecord::RecordNotFound
      status 404
    end
	end

  ### Adhesiones

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

  ### Oferta Normativa

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

  ### Error Handling
 
  not_found do
    "404 Not Found"
  end

  error 403 do
    'Access forbidden'
  end

  error 500 do
    'Internal Server Errror'
  end

  ## Helpers

  def extract(object, attribute)
    object.respond_to?(attribute) ? object.send(attribute) : object
  end

  def entity_path(entity)
    id = extract(entity, :id)
    "/entity/#{id}"
  end

  def entity_url(entity)
    url entity_path(entity)
  end
end
