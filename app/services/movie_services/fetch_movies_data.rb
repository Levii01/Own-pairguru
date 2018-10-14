module MovieServices
  class FetchMoviesData < ApplicationService
    include Dry::Monads::Do.for(:call)

    def call(movies)
      {}.tap do |hash|
        movies.pluck(:id, :title).map { |id, title| hash[id] = GetMovieData.call(title).success }
      end
    end
  end
end
