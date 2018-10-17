module Types
  class MovieType < Types::BaseObject
    description "the movie details"

    field :id, ID, null: false
    field :title, String, null: false
  end
end
