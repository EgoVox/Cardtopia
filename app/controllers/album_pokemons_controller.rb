class AlbumPokemonsController < ApplicationController

  def new
    load_collection_and_album
    @seasons = Season.includes(:extensions).all
    # find extension if user click on button season
    @extensions = Extension.where("season_id = ?", params[:season_id]) if params[:season_id].present?
    search_pokemon

  end

  def create
    @album = Album.find(params[:album_id])
    @pokemon = Pokemon.find(params[:pokemon_id])
    @album_pokemon = AlbumPokemon.new(album: @album, pokemon: @pokemon)
    @album_pokemon.save ? redirect_to(album_path(@album), notice: 'Pokemon ajouté avec succès.') : render(:new)
  end

def destroy_multiple
  pokemon_ids = params[:pokemon_ids].split(',')
  AlbumPokemon.where(pokemon_id: pokemon_ids).destroy_all
  head :no_content
end

  private

  def load_collection_and_album
    @album = Album.find(params[:album_id])
    @collection = @album.collection
  end

  def search_pokemon
    if params[:type].present? && params[:extension_id].present?
      @pokemons = Pokemon.where("extension_id = ?", params[:extension_id])
      @pokemons = @pokemons.where("metadata @> ?", { types: [I18n.t("pokemon_types.#{params[:type]}")] }.to_json)
    elsif params[:extension_id].present?
      # find pokemon where user click on button extension
      @pokemons = Pokemon.where("extension_id = ?", params[:extension_id])
    elsif params[:name].present?
    # find pokemon where user put name
      @pokemons = Pokemon.where("pokemon_name ILIKE ? OR pokemon_id ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%")
    end
  end
end
