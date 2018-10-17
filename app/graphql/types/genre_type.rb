module Types
  class GenreType < Types::BaseObject
    description "the genre details"

    field :id, ID, null: false
    field :name, String, null: false
    field :number_of_movies, Int, null: false

    def number_of_movies
      context[:number_of_genres] ? context[:number_of_genres][object.id] : object.movies.size
    end
  end
end
