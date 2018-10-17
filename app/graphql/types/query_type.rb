module Types
  class QueryType < Types::BaseObject
    description "the query root of this schema"

    field :movies, [Types::MovieType], null: true do
      description "the Movies list or specific Movie by ID"
      argument :id, ID, required: false, default_value: false
    end

    def movies(id:)
      id ? Movie.where(id: id) : Movie.all
    end
  end
end
