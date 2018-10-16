module MovieServices
  class FetchMoviesData < ApplicationService
    def call(movies)
      return {} if movies.empty?
      fetch_data(movies)
    end

    def fetch_data(movies)
      {}.tap do |hash|
        # a = GetMovieData.call(movies.first.title)
        movies.pluck(:id, :title).map { |id, title| hash[id] = GetMovieData.call(title).success }
      end
    end
  end
end
