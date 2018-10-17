module Types
  class MovieType < Types::BaseObject
    description "the movie details"

    field :id, ID, null: false
    field :title, String, null: false
    field :genre, GenreType, null: false

    def genre
      object.genre
    end
  end
end
