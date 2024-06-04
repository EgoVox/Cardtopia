class PokemonsController < ApplicationController
  # Recherche les Pokémon par leur nom

  # Affiche le formulaire pour ajouter un nouveau Pokémon
  def new
    @collection = Collection.find(params[:collection_id])
    @album = Album.find(params[:album_id])
    @pokemons = Pokemon.new_user_collection_album_pokemon(params[:name]) if params[:name].present?
      @pokemons = []
  end


  # Crée un nouveau Pokémon dans l'album spécifié
  def create
    @collection = Collection.find(params[:collection_id])
    @album = Album.find(params[:album_id])
    @pokemon = Pokemon.new(pokemon_params)
    if @pokemon.save
      redirect_to collection_album_path(@collection, @album), notice: 'Pokemon added successfully.'
    else
      render :new
    end
  end

  private

  # Définit les paramètres autorisés pour la création d'un Pokémon
  def pokemon_params
    params.require(:pokemon).permit(:name, :type, :level, :ability)
  end
end
