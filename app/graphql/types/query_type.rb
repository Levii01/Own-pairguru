module Types
  class QueryType < Types::BaseObject
    description "the query root of this schema"

    field :movies, [Types::MovieType], null: true do
      description "the Movies list or specific Movie by ID"
      argument :id, ID, required: false, default_value: false
    end

    def movies(id:)
      if id
        Movie.where(id: id)
      elsif context[:query].include?("genre")
        movies = Movie.includes(:genre)
        context[:number_of_genres] = movies.group(:genre_id).pluck(:genre_id, "COUNT('id')").to_h
        movies
      else
        Movie.all
      end
    end
  end
end
