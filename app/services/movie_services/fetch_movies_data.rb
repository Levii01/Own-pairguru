module MovieServices
  class FetchMoviesData < ApplicationService
    def call(movies)
      return {} if movies.empty?
      fetch_data(movies)
    end

    def fetch_data(movies)
      {}.tap do |hash|
        movies.pluck(:id, :title).map { |id, title| hash[id] = GetMovieData.call(title) }
      end
    end
  end
end
