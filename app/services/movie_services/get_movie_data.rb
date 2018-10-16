require "net/http"

module MovieServices
  class GetMovieData < ApplicationService
    def call(title)
      request = get_url(title)
      get_movie_data(request)
    end

    def get_movie_data(request)
      response = Net::HTTP.get(request)
      parse_movie_attributes(response)
    end

    def parse_movie_attributes(response)
      response = JSON.parse(response)
      return {} if response["message"]
      parse_response(response)
    end

    def get_url(movie_name)
      URI.parse("#{Rails.configuration.movie_api_url}/api/v1/movies/#{URI.encode(movie_name)}")
    end

    def parse_response(response)
      response["data"]["attributes"].with_indifferent_access
    end
  end
end
