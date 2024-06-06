class Pokemon < ApplicationRecord
  has_many :album_pokemons
  has_many :albums, through: :album_pokemons

  validates :pokemon_name, presence: true

  TYPES = [:fire, :water, :grass, :electric, :normal, :fighting, :flying, :poison, :ground, :rock, :bug, :ghost, :steel, :ice, :psychic, :dragon, :dark, :fairy]

  def self.with_extension_and_season
    joins(extension: :season)
      .select('pokemons.*, extensions.extension_name, seasons.season_name')
  end

  def pokemon_type
    type = self.metadata['types']&.first || 'unknown'
    I18n.t("pokemon_types").key(type)
  end
end
