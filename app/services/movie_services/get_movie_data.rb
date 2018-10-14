require 'net/http'

module MovieServices
  class GetMovieData < ApplicationService
    def call(movie)
      get_movie_data(get_url(movie.title))
    end

    def get_movie_data(request)
      result = Net::HTTP.get(request)
      JSON.parse(result)['data'].with_indifferent_access
    end

    def get_url(movie_name)
      URI.parse("#{Rails.configuration.movie_api_url}/api/v1/movies/#{movie_name}")
    end
  end
end
